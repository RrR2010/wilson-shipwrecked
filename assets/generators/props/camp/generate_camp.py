"""Reference 03: deterministic chunky camp props. Run with Blender 5.2."""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import random
import sys

sys.dont_write_bytecode = True

import bpy
from mathutils import Vector

REPO = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(REPO / 'tools/blender'))
from _workflow_common import create_material, ensure_supported_blender, world_bounds, create_contact_sheet
import review_asset
import validate_asset
import export_asset

ASSETS = {
    'stool_crude_slab_01': 'props/furniture',
    'bench_simple_plank_01': 'props/furniture',
    'basket_small_woven_01': 'props/containers',
    'bowl_wood_01': 'props/containers',
    'ship_crate_wood_01': 'props/containers',
    'display_shelf_raised_01': 'props/furniture',
    'drying_rack_basic_01': 'structures/camp',
    'fire_site_stone_01': 'structures/camp',
}


class Builder:
    def __init__(self, asset_id, seed):
        self.rng = random.Random(seed)
        name = 'ASSET_' + asset_id
        old = bpy.data.collections.get(name)
        if old:
            if old.get('generator') != 'reference_03':
                raise RuntimeError('Refusing to replace a foreign collection: ' + name)
            for obj in list(old.objects):
                bpy.data.objects.remove(obj, do_unlink=True)
            bpy.data.collections.remove(old)
        self.collection = bpy.data.collections.new(name)
        self.collection['generator'] = 'reference_03'
        bpy.context.scene.collection.children.link(self.collection)
        self.root = bpy.data.objects.new(asset_id, None)
        self.collection.objects.link(self.root)
        self.root['generator_seed'] = seed
        self.root['authored_forward'] = '+Y'
        self.materials = {}
        colors = {'wood': (.32,.145,.044,1), 'wood_light': (.43,.225,.075,1),
                  'endgrain': (.52,.30,.115,1), 'wood_dark': (.235,.10,.032,1),
                  'rope': (.60,.425,.19,1), 'stone': (.29,.275,.235,1),
                  'stone_light': (.37,.35,.295,1), 'iron': (.16,.17,.16,1),
                  'ash': (.115,.105,.086,1), 'fiber': (.48,.285,.085,1),
                  'fiber_light': (.54,.325,.105,1), 'cloth': (.65,.53,.32,1)}
        for key, color in colors.items():
            name = 'camp_' + key
            self.materials[key] = bpy.data.materials.get(name) or create_material(name, color, roughness=.88)

    def adopt(self, obj, name, material):
        obj.name = self.root.name + '__' + name
        for col in list(obj.users_collection):
            col.objects.unlink(obj)
        self.collection.objects.link(obj)
        obj.parent = self.root
        if material:
            obj.data.materials.append(self.materials[material])
        return obj

    def mesh(self, name, verts, faces, material):
        data = bpy.data.meshes.new(self.root.name + '__' + name)
        data.from_pydata(verts, [], faces)
        data.update()
        obj = bpy.data.objects.new(data.name, data)
        self.collection.objects.link(obj)
        obj.parent = self.root
        data.materials.append(self.materials[material])
        return obj

    def anchor(self, name, location):
        # Blender object names are global even across separate asset scopes.
        # Explicit suffixes keep roles stable regardless of generation order.
        obj = bpy.data.objects.new(name + '__' + self.root.name, None)
        self.collection.objects.link(obj)
        obj.parent = self.root
        obj.location = location
        obj['semantic_role'] = name
        obj.empty_display_size = .06
        return obj

    def box(self, name, center, size, material='wood', bevel=.012):
        bpy.ops.mesh.primitive_cube_add(size=1, location=center)
        obj = self.adopt(bpy.context.object, name, material)
        obj.scale = size
        bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
        if bevel:
            mod = obj.modifiers.new('Broad hewn corners', 'BEVEL')
            mod.width = bevel
            mod.segments = 1
            bpy.ops.object.modifier_apply(modifier=mod.name)
        return obj

    def pole(self, name, a, b, radius=.065, material='wood', sides=7):
        a, b = Vector(a), Vector(b)
        length = (b-a).length
        verts = []
        radial = [self.rng.uniform(.93,1.07) for _ in range(sides)]
        for z, scale in [(0,.91),(.018,1),(length*.52,.95),(length-.012,.91),(length,.79)]:
            for i in range(sides):
                angle = i*math.tau/sides
                verts.append((radius*scale*radial[i]*math.cos(angle), radius*scale*radial[i]*math.sin(angle),z))
        faces = [tuple(reversed(range(sides)))]
        for j in range(4):
            for i in range(sides):
                k = j*sides+i; n = j*sides+(i+1)%sides
                faces.append((k,n,n+sides,k+sides))
        faces.append(tuple(range(4*sides,5*sides)))
        obj = self.mesh(name,verts,faces,material)
        obj.location = a
        obj.rotation_mode = 'QUATERNION'
        obj.rotation_quaternion = (b-a).to_track_quat('Z','Y')
        obj.data.materials.append(self.materials['endgrain' if material == 'wood' else material])
        obj.data.polygons[-1].material_index = 1
        return obj

    def plank(self, name, center, size):
        """Broad hand-hewn planes, with shared edges and a stable usable top."""
        length,width,height=size
        cross=[(-.40,-.5),(.40,-.5),(.5,-.30),(.5,.30),(.40,.5),(-.40,.5),(-.5,.30),(-.5,-.30)]
        verts=[]
        for j,t in enumerate([-.5,-.46,-.12,.23,.47,.5]):
            taper=.9 if j in (0,5) else 1
            dy=self.rng.uniform(-.014,.014)*width
            dz=self.rng.uniform(-.035,.035)*height
            for k,(y,z) in enumerate(cross):
                verts.append((length*t,y*width*taper+dy,z*height*taper+dz))
        faces=[tuple(reversed(range(8)))]
        for j in range(5):
            for k in range(8):
                faces.append((j*8+k,j*8+(k+1)%8,(j+1)*8+(k+1)%8,(j+1)*8+k))
        faces.append(tuple(range(40,48)))
        obj=self.mesh(name,verts,faces,'wood_light')
        obj.location=center
        obj.data.materials.append(self.materials['wood'])
        for poly in obj.data.polygons:
            if poly.index in [4,14,27]: poly.material_index=1
        return obj

    def tube(self, name, points, radius=.018, material='rope', sides=5, closed=False):
        pts = [Vector(p) for p in points]
        verts=[]; faces=[]
        for i,p in enumerate(pts):
            tangent = pts[(i+1)%len(pts)]-pts[i-1] if closed else pts[min(i+1,len(pts)-1)]-pts[max(i-1,0)]
            tangent.normalize()
            ref = Vector((0,0,1)) if abs(tangent.z)<.9 else Vector((0,1,0))
            u=tangent.cross(ref).normalized(); v=tangent.cross(u).normalized()
            verts.extend(tuple(p+radius*(math.cos(k*math.tau/sides)*u+math.sin(k*math.tau/sides)*v)) for k in range(sides))
        for i in range(len(pts) if closed else len(pts)-1):
            for k in range(sides):
                faces.append((i*sides+k,i*sides+(k+1)%sides,((i+1)%len(pts))*sides+(k+1)%sides,((i+1)%len(pts))*sides+k))
        if not closed:
            faces.extend([tuple(reversed(range(sides))),tuple(range((len(pts)-1)*sides,len(pts)*sides))])
        return self.mesh(name,verts,faces,material)

    def binding(self, name, center, radius=.093):
        x,y,z=center
        for j in range(3):
            self.tube(name+str(j),[(x+radius*math.cos(i*math.tau/12),y+radius*math.sin(i*math.tau/12),z+(j-1)*.031+.009*math.sin(i*math.tau/12)) for i in range(12)],.018,closed=True)
        self.tube(name+'_cross',[(x-radius*.7,y+radius,z-radius*.62),(x,y+radius+.012,z),(x+radius*.7,y+radius,z+radius*.62)],min(.022,radius*.25))

    def lathe(self,name,profile,material='wood_light',n=16):
        verts=[]
        radial=[self.rng.uniform(.975,1.025) for _ in range(n)]
        for radius,z in profile:
            for i in range(n):
                a=i*math.tau/n
                verts.append((radius*radial[i]*math.cos(a),radius*radial[i]*math.sin(a),z))
        faces=[]
        for j in range(len(profile)-1):
            for i in range(n):
                faces.append((j*n+i,j*n+(i+1)%n,(j+1)*n+(i+1)%n,(j+1)*n+i))
        faces.extend([tuple(reversed(range(n))),tuple(range((len(profile)-1)*n,len(profile)*n))])
        return self.mesh(name,verts,faces,material)


def stool(b):
    for i in range(3):
        a=math.pi/2+i*math.tau/3
        b.pole('leg_'+str(i),(.235*math.cos(a),.235*math.sin(a),.012),(.15*math.cos(a),.15*math.sin(a),.41),.052)
    seat=b.lathe('slab',[(.205,.375),(.25,.389),(.257,.463),(.233,.48),(.16,.481),(.01,.482)],'wood',24)
    seat.data.materials.append(b.materials['endgrain'])
    for vertex in seat.data.vertices:
        if vertex.index%24 in [2,10,18] and vertex.index//24 < 4:
            vertex.co.x*=.88; vertex.co.y*=.88
    for poly in seat.data.polygons:
        if poly.index>=72: poly.material_index=1
    for r in [.085,.16]:
        b.tube('growth_ring',[(r*math.cos(i*math.tau/18),r*math.sin(i*math.tau/18),.483) for i in range(18)],.0025,'wood_light',3,True)
    b.anchor('ANCHOR_SEAT',(0,0,.485)); b.anchor('ANCHOR_APPROACH',(0,.65,0))


def bench(b):
    for x in [-.55,.55]:
        for y in [-.135,.135]:
            b.box('leg',(x,y,.2),(.125,.13,.4),bevel=.018)
        b.box('support',(x,0,.376),(.145,.43,.09))
    b.box('stretcher',(0,0,.20),(1.12,.075,.10),'wood_dark')
    for i,y in enumerate([-.155,0,.155]):
        obj=b.plank('seat_plank_'+str(i),(0,y,.445),(1.46+(.025 if i==1 else 0),.148,.105))
        obj.rotation_euler.z=[.004,-.006,.003][i]
    b.anchor('ANCHOR_SEAT',(0,0,.5)); b.anchor('ANCHOR_APPROACH',(0,.7,0))


def bowl(b):
    b.lathe('hollow_bowl',[(.09,0),(.132,.012),(.182,.066),(.21,.137),(.205,.156),(.181,.157),(.174,.132),(.142,.079),(.083,.034),(.003,.032)],'wood_light',16)
    b.anchor('ANCHOR_PICKUP',(0,0,.09)); b.anchor('SOCKET_CONTENTS',(0,0,.06))


def basket(b):
    b.lathe('basket_wall',[(.135,0),(.166,.035),(.204,.17),(.217,.29),(.19,.29),(.176,.16),(.143,.041),(.002,.035)],'fiber',16)
    for j in range(5):
        z=.043+j*.053
        for i in range(16):
            a=(i+(j%2)*.5)*math.tau/16
            verts=[]
            for zz in [z-.024,z+.024]:
                radius=(.166+(zz-.035)*(.038/.135)) if zz<.17 else (.204+(zz-.17)*(.013/.12))
                for r in [radius+.006,radius+.023]:
                    for angle in [a-.187,a+.187]:
                        verts.append((r*math.cos(angle),r*math.sin(angle),zz))
            b.mesh('broad_weave',verts,[(0,1,3,2),(4,6,7,5),(0,4,5,1),(2,3,7,6),(0,2,6,4),(1,5,7,3)],'fiber_light' if (i+j)%3==0 else 'fiber')
    for z,r in [(.285,.205),(.308,.206)]:
        b.tube('rim',[(r*math.cos(i*math.tau/16),r*math.sin(i*math.tau/16),z) for i in range(16)],.021,'rope',6,True)
    b.tube('handle',[(.202*math.cos(i*math.pi/12),0,.295+.22*math.sin(i*math.pi/12)) for i in range(13)],.026,'fiber',6)
    for x in [-.20,.20]: b.binding('handle_lashing',(x,0,.30),.034)
    b.anchor('ANCHOR_PICKUP',(0,0,.515)); b.anchor('SOCKET_CONTENTS',(0,0,.11))


def crate(b):
    for i in range(4):
        t=(i-1.5)*.14
        b.box('floor',(t,0,.032),(.134,.56,.064),'wood_dark',.006)
        for y in [-.273,.273]: b.box('wall',(t,y,.295),(.135,.045,.52),'wood',.007)
        for x in [-.273,.273]: b.box('side',(x,t,.295),(.045,.135,.52),'wood_light',.007)
    for x in [-.263,.263]:
        for y in [-.298,.298]:
            b.box('corner',(x,y,.30),(.082,.063,.60),'wood_light',.009)
    for z in [.06,.54]:
        for y in [-.316,.316]:
            b.box('rail',(0,y,z),(.64,.065,.087),'wood_light',.009)
            for x in [-.263,.263]: b.box('square_fastener',(x,y+(.038 if y>0 else -.038),z),(.032,.016,.032),'iron',.004)
        for x in [-.292,.292]: b.box('side_rail',(x,0,z),(.064,.61,.084),'wood_light',.007)
    brace=b.box('front_diagonal',(0,.32,.30),(.083,.052,.62),'wood_light',.008)
    brace.rotation_euler.y=.73
    lid=b.anchor('SOCKET_LID',(0,-.27,.594))
    for i in range(4):
        obj=b.box('lid_plank',((i-1.5)*.14,0,.60),(.135,.55,.045),'wood_light',.006)
        obj.parent=lid; obj.location-=lid.location
    b.anchor('ANCHOR_PICKUP',(0,0,.30)); b.anchor('SOCKET_CONTENTS',(0,0,.16))


def shelf(b):
    for x in [-.46,.46]:
        for y in [-.205,.205]:
            b.pole('post',(x,y,0),(x,y,.92),.063)
            for z in [.20,.75]: b.binding('shelf_binding',(x,y,z),.079)
    for z in [.20,.75]:
        for x in [-.46,.46]: b.box('bearer',(x,0,z-.045),(.11,.53,.09),'wood_dark')
        for i,y in enumerate([-.155,0,.155]):
            b.plank('shelf_plank',(0,y,z),(.99+i*.006,.145,.078))
    b.anchor('SOCKET_TOP_01',(0,0,.79)); b.anchor('SOCKET_TOP_02',(0,0,.24))
    b.anchor('ANCHOR_APPROACH',(0,.7,0))


def rack(b):
    for x in [-.68,.68]:
        for sign in [-1,1]:
            b.pole('trestle',(x,sign*.40,.025),(x,-sign*.06,1.43),.064)
        b.binding('joint',(x,0,1.26),.097)
        b.pole('foot_brace',(x,-.28,.37),(x,.28,.37),.035)
    b.pole('crossbar',(-.83,0,1.28),(.83,0,1.30),.062)
    for i,x in enumerate([-.36,0,.36]):
        b.anchor('SOCKET_HANG_'+str(i+1).zfill(2),(x,0,1.23))
        b.tube('hanging_loop',[(x,-.057,1.31),(x,.02,1.36),(x,.07,1.27),(x,.02,1.12)],.015)
        # Independent removable presentation sample, not an inventory or food owner.
        sample=b.mesh('hanging_sample_'+str(i),[(x-.026,0,1.16),(x+.026,0,1.16),(x+.065,.018,.91),(x+.048,0,.77),(x+.005,-.025,.79),(x-.025,0,.73),(x-.066,.015,.90),(x, -.035,.98)],[(0,1,7),(1,2,7),(2,3,7),(3,4,7),(4,5,7),(5,6,7),(6,0,7)],'cloth')
        solid=sample.modifiers.new('Cloth thickness','SOLIDIFY'); solid.thickness=.008
    b.anchor('ANCHOR_APPROACH',(0,.85,0))


def fire(b):
    b.lathe('site_bed',[(.49,.002),(.52,.018),(.46,.036),(.01,.039)],'ash',14)
    for i in range(11):
        a=i*math.tau/11; r=.52+b.rng.uniform(-.015,.015)
        obj=b.box('boundary_stone_'+str(i),(r*math.cos(a),r*math.sin(a),.115),(.29,.31,.23),'stone_light' if i%3==0 else 'stone',.058)
        for v in obj.data.vertices:
            v.co.x*=b.rng.uniform(.89,1.09)
            v.co.y*=b.rng.uniform(.94,1.06)
            if v.co.z>0: v.co.z*=b.rng.uniform(.90,1.10)
        obj.rotation_euler.z=a
    for i in range(5):
        a=i*math.tau/5
        b.pole('fuel_'+str(i),(.31*math.cos(a),.31*math.sin(a),.095),(.055*math.cos(a),.055*math.sin(a),.40),.058)
    b.anchor('ANCHOR_COOK',(0,0,.52)); b.anchor('SOCKET_FIRE',(0,0,.22))
    b.anchor('ANCHOR_APPROACH',(0,.95,0))


BUILDERS = dict(zip(ASSETS,[stool,bench,basket,bowl,crate,shelf,rack,fire]))


def invoke(module,args):
    previous=sys.argv
    try:
        sys.argv=[module.__file__,'--']+args
        return module.main()
    finally:
        sys.argv=previous


def save_workbench(asset_ids, workbench_id='reference_03'):
    name='WORKBENCH_' + workbench_id
    old=bpy.data.scenes.get(name)
    if old:
        for obj in list(old.objects):
            bpy.data.objects.remove(obj,do_unlink=True)
        bpy.data.scenes.remove(old)
    scene=bpy.data.scenes.new(name)
    scene.unit_settings.system='METRIC'
    for index,asset_id in enumerate(asset_ids):
        obj=bpy.data.objects.new('DISPLAY_'+asset_id,None)
        obj.instance_type='COLLECTION'
        obj.instance_collection=bpy.data.collections['ASSET_'+asset_id]
        obj.location=((index%4)*2.0,(index//4)*2.1,0)
        scene.collection.objects.link(obj)
    if bpy.context.window:
        bpy.context.window.scene=scene
    destination=REPO/('assets/generated/props/camp/' + workbench_id + '_workbench.blend')
    destination.parent.mkdir(parents=True,exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(destination))


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--asset',choices=['all']+list(ASSETS),default='all')
    parser.add_argument('--seed',type=int,default=3)
    parser.add_argument('--stage',choices=['build','review','export'],default='review')
    args=parser.parse_args(sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else [])
    ensure_supported_blender(False)
    bpy.context.scene.unit_settings.system='METRIC'
    bpy.context.scene.unit_settings.scale_length=1
    bpy.context.preferences.filepaths.file_preview_type = 'NONE'
    selected=ASSETS if args.asset=='all' else [args.asset]
    expectations=[]
    gameplay_images=[]
    for asset_id in selected:
        b=Builder(asset_id,args.seed)
        BUILDERS[asset_id](b)
        bpy.context.view_layer.update()
        common=['--asset-id',asset_id,'--scope-kind','collection','--scope-name','ASSET_'+asset_id]
        invoke(validate_asset,common+['--profile','static','--category',ASSETS[asset_id]])
        if args.stage=='review':
            manifest=invoke(review_asset,common+['--resolution-x','960','--resolution-y','720'])
            gameplay_images.append(REPO/manifest['renders']['gameplay'])
        elif args.stage=='export':
            invoke(export_asset,common+['--profile','static','--category',ASSETS[asset_id],'--source-mode','generator','--generator-source',Path(__file__).relative_to(REPO).as_posix(),'--generator-seed',str(args.seed)])
            bounds=world_bounds(list(b.collection.objects))
            anchors={obj.name:list(obj.matrix_world.translation) for obj in b.collection.objects if obj.type=='EMPTY' and obj!=b.root}
            expectations.append({'asset_id':asset_id,'path':'res://assets/models/'+ASSETS[asset_id]+'/'+asset_id+'.glb','bounds':bounds,'anchors':anchors})
        print('CAMP PASS',args.stage,asset_id,flush=True)
    if expectations:
        target=REPO/'temp/camp-import-expectations.json'
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_text(json.dumps(expectations,indent=2),encoding='utf-8')
    if gameplay_images:
        target=REPO/'assets/previews/props/camp/reference_03_overview.png'
        target.parent.mkdir(parents=True,exist_ok=True)
        create_contact_sheet(gameplay_images,target,columns=4,tile_scale=.6)
    save_workbench(selected)


if __name__=='__main__':
    main()
