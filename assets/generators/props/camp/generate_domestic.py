"""Cooking and storage continuation from Reference 03/10; Blender-only review."""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import bpy
from generate_camp import (
    Builder, REPO, create_contact_sheet, ensure_supported_blender,
    invoke, review_asset, validate_asset, export_asset, save_workbench, world_bounds,
)

ASSETS = {
    'work_surface_plank_01': 'props/furniture',
    'bucket_wood_01': 'props/containers',
    'storage_box_wood_01': 'props/containers',
    'pot_iron_01': 'props/containers',
    'cup_wood_01': 'props/containers',
    'spoon_utensil_wood_01': 'props/tools',
}


def hoop(b, name, radius, z, height, material='iron'):
    profile=[(radius-.009,z-height/2),(radius+.012,z-height/2),
             (radius+.016,z-height*.30),(radius+.016,z+height*.30),
             (radius+.009,z+height/2),(radius-.009,z+height/2)]
    verts=[(r*math.cos(i*math.tau/16),r*math.sin(i*math.tau/16),h)
           for r,h in profile for i in range(16)]
    faces=[]
    for j in range(len(profile)):
        nxt=(j+1)%len(profile)
        for i in range(16):
            faces.append((j*16+i,j*16+(i+1)%16,nxt*16+(i+1)%16,nxt*16+i))
    return b.mesh(name,verts,faces,material)


def work_surface(b):
    for x in [-.55,.55]:
        for y in [-.285,.285]:
            b.pole('leg',(x*1.06,y*1.08,.005),(x,y,.76),.073)
            b.binding('upper_joint',(x,y,.70),.085)
        b.box('top_bearer',(x,0,.72),(.15,.73,.10),'wood_dark',.014)
        b.box('foot_rail',(x,0,.18),(.12,.67,.12),'wood',.014)
    b.box('long_stretcher',(0,0,.19),(1.20,.105,.12),'wood',.015)
    for x in [-.52,.52]:
        b.pole('diagonal_brace',(x,0,.22),(x*.52,0,.765),.04)
    for i,y in enumerate([-.294,-.098,.098,.294]):
        plank=b.plank('top_plank_'+str(i),(0,y,.80),(1.46+[.01,-.015,.025,0][i],.189,.11))
        plank.rotation_euler.z=[.002,-.003,.004,-.003][i]
    b.anchor('SOCKET_TOP_01',(-.34,0,.857))
    b.anchor('SOCKET_TOP_02',(.34,0,.857))
    b.anchor('ANCHOR_APPROACH',(0,.90,0))


def bucket(b):
    # Each broad stave includes an inner face: the rim is genuinely open.
    count=14
    for i in range(count):
        a=i*math.tau/count
        half=math.pi/count-.004
        top=.35+b.rng.uniform(-.007,.007)
        verts=[]
        for z,outer,inner in [(0,.145,.119),(.018,.158,.126),(top,.201,.173)]:
            for radius in [inner,outer]:
                for angle in [a-half,a+half]:
                    verts.append((radius*math.cos(angle),radius*math.sin(angle),z))
        faces=[(0,1,3,2),(8,10,11,9)]
        for j in range(2):
            k=j*4
            faces.extend([(k,k+4,k+5,k+1),(k+2,k+3,k+7,k+6),
                          (k,k+2,k+6,k+4),(k+1,k+5,k+7,k+3)])
        b.mesh('stave_'+str(i),verts,faces,'wood_light' if i%4==0 else 'wood')
    b.lathe('bottom',[(.139,.007),(.147,.032),(.001,.034)],'wood_dark',14)
    hoop(b,'lower_hoop',.169,.085,.045)
    hoop(b,'upper_hoop',.192,.278,.049)
    for x in [-.212,.212]:
        b.box('handle_lug',(x,0,.30),(.029,.052,.066),'iron',.008)
    b.tube('arched_handle',[(.214*math.cos(i*math.pi/12),0,.31+.235*math.sin(i*math.pi/12)) for i in range(13)],.018,'iron',6)
    b.pole('handle_grip',(-.061,0,.545),(.061,0,.545),.026,'wood_dark',8)
    b.anchor('ANCHOR_PICKUP',(0,0,.557))
    b.anchor('SOCKET_CONTENTS',(0,0,.15))


def storage_box(b):
    b.box('floor',(0,0,.035),(.76,.44,.07),'wood_dark',.01)
    for z in [.105,.229,.353]:
        for y in [-.23,.23]:
            b.plank('wall_plank',(0,y,z),(.79,.052,.117))
        for x in [-.385,.385]:
            obj=b.plank('end_plank',(x,0,z),(.475,.052,.117))
            obj.rotation_euler.z=math.pi/2
    for x in [-.344,.344]:
        for y in [-.26,.26]:
            b.box('corner_strap',(x,y,.219),(.065,.028,.377),'wood',.008)
    hinge=b.anchor('SOCKET_LID',(0,-.24,.423))
    lid_parts=[]
    for i,y in enumerate([-.185,-.061,.063,.187]):
        lid_parts.append(b.plank('lid_plank_'+str(i),(0,y,.449),(.838,.120,.065)))
    for x in [-.29,.29]:
        lid_parts.append(b.box('lid_cleat',(x,0,.416),(.07,.445,.035),'wood_dark',.006))
        b.box('hinge_plate',(x,-.273,.403),(.083,.023,.072),'iron',.006)
    # Large, readable hasp follows the lid; keeper remains on the box body.
    lid_parts.append(b.box('lid_hasp',(0,.275,.391),(.066,.025,.143),'iron',.007))
    b.box('keeper',(0,.293,.352),(.037,.018,.035),'wood_dark',.005)
    for obj in lid_parts:
        obj.parent=hinge
        obj.location-=hinge.location
    b.anchor('ANCHOR_OPEN',(0,.31,.40))
    b.anchor('SOCKET_CONTENTS',(0,0,.18))


def pot(b):
    b.lathe('hollow_pot',[(.135,0),(.179,.025),(.218,.09),(.229,.19),(.207,.284),
                         (.209,.306),(.181,.306),(.181,.279),(.201,.188),
                         (.19,.095),(.14,.048),(.003,.045)],'iron',14)
    hoop(b,'rolled_lip',.20,.298,.026)
    for sign in [-1,1]:
        b.box('ear',(sign*.214,0,.263),(.038,.053,.070),'iron',.009)
    b.tube('bail',[(.222*math.cos(i*math.pi/14),0,.27+.245*math.sin(i*math.pi/14)) for i in range(15)],.014,'iron',6)
    b.anchor('ANCHOR_PICKUP',(0,0,.529))
    b.anchor('SOCKET_CONTENTS',(0,0,.16))


def cup(b):
    obj=b.lathe('carved_cup',[(.058,0),(.079,.014),(.087,.09),(.091,.174),
                            (.087,.191),(.066,.193),(.063,.171),(.061,.057),
                            (.043,.030),(.002,.029)],'wood',12)
    obj.data.materials.append(b.materials['endgrain'])
    for face in obj.data.polygons:
        if 48<=face.index<60: face.material_index=1
    # Few broad exterior planes, not modeled grain or separate fragile fibers.
    obj.data.materials.append(b.materials['wood_dark'])
    for face in obj.data.polygons:
        if face.index<48 and face.index%12 in [2,7]: face.material_index=2
    b.anchor('ANCHOR_PICKUP',(0,0,.10))
    b.anchor('SOCKET_CONTENTS',(0,0,.09))


def spoon(b):
    scoop=b.lathe('scoop',[(.043,0),(.071,.01),(.098,.048),(.10,.068),
                          (.084,.071),(.076,.047),(.039,.021),(.002,.020)],'wood_light',14)
    for vert in scoop.data.vertices: vert.co.y*=1.15
    scoop.location.y=.105
    verts=[]
    for y,width,z in [(-.33,.016,.013),(-.303,.024,.018),(-.12,.018,.042),(.022,.027,.06)]:
        verts.extend([(-width,y,z-.009),(width,y,z-.009),(width,y,z+.009),(-width,y,z+.009)])
    faces=[(0,1,2,3)]
    for j in range(3):
        for k in range(4): faces.append((4*j+k,4*(j+1)+k,4*(j+1)+(k+1)%4,4*j+(k+1)%4))
    faces.append((15,14,13,12))
    b.mesh('handle',verts,faces,'wood_light')
    b.anchor('ANCHOR_PICKUP',(0,-.18,.045))


BUILDERS=dict(zip(ASSETS,[work_surface,bucket,storage_box,pot,cup,spoon]))


def check_geometry(b):
    """Check real output topology and physical bounds, not only scope wiring."""
    triangles=0
    for obj in b.collection.objects:
        if obj.type!='MESH': continue
        mesh=obj.data
        assert all(all(math.isfinite(c) for c in v.co) for v in mesh.vertices),obj.name
        mesh.calc_loop_triangles()
        triangles+=len(mesh.loop_triangles)
        assert all(p.area>1e-10 for p in mesh.polygons), 'Degenerate face: '+obj.name
        edge_uses={}
        for face in mesh.polygons:
            for edge in face.edge_keys:
                key=tuple(sorted(edge))
                edge_uses[key]=edge_uses.get(key,0)+1
        assert all(count==2 for count in edge_uses.values()), 'Open solid: '+obj.name
        volume=sum(mesh.vertices[t.vertices[0]].co.dot(
                   mesh.vertices[t.vertices[1]].co.cross(mesh.vertices[t.vertices[2]].co))
                   for t in mesh.loop_triangles)/6
        assert volume>1e-9, 'Inverted or empty solid: '+obj.name
    bounds=world_bounds(list(b.collection.objects))
    assert -.02<bounds['min'][2]<.03, bounds
    assert 0<triangles<10000,triangles
    return {'triangles':triangles,'bounds':bounds}


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--asset',choices=['all']+list(ASSETS),default='all')
    parser.add_argument('--stage',choices=['build','review','export'],default='review')
    parser.add_argument('--seed',type=int,default=3)
    args=parser.parse_args(sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else [])
    ensure_supported_blender(False)
    bpy.context.scene.unit_settings.system='METRIC'
    bpy.context.preferences.filepaths.file_preview_type='NONE'
    selected=ASSETS if args.asset=='all' else [args.asset]
    images=[]; report={}
    for asset_id in selected:
        b=Builder(asset_id,args.seed)
        BUILDERS[asset_id](b)
        bpy.context.view_layer.update()
        report[asset_id]=check_geometry(b)
        common=['--asset-id',asset_id,'--scope-kind','collection','--scope-name','ASSET_'+asset_id]
        invoke(validate_asset,common+['--profile','static','--category',ASSETS[asset_id]])
        if args.stage=='review':
            manifest=invoke(review_asset,common+['--resolution-x','960','--resolution-y','720'])
            images.append(REPO/manifest['renders']['gameplay'])
            if asset_id=='storage_box_wood_01':
                hinge=bpy.data.objects['SOCKET_LID__'+asset_id]
                hinge.rotation_euler.x=math.radians(105)
                bpy.context.view_layer.update()
                invoke(review_asset,common+['--resolution-x','960','--resolution-y','720',
                       '--output-root',str(REPO/'temp/blender-review-domestic-states')])
                hinge.rotation_euler.x=0
                bpy.context.view_layer.update()
        elif args.stage=='export':
            invoke(export_asset,common+['--profile','static','--category',ASSETS[asset_id],
                   '--source-mode','generator','--generator-source',Path(__file__).relative_to(REPO).as_posix(),
                   '--generator-seed',str(args.seed)])
        print('DOMESTIC PASS',args.stage,asset_id,report[asset_id]['triangles'],'triangles',flush=True)
    if images:
        target=REPO/'assets/previews/props/camp/domestic_overview.png'
        target.parent.mkdir(parents=True,exist_ok=True)
        create_contact_sheet(images,target,columns=3,tile_scale=.65)
    target=REPO/'temp/domestic-validation.json'
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(json.dumps(report,indent=2),encoding='utf-8')
    save_workbench(selected,'domestic')


if __name__=='__main__':
    main()
