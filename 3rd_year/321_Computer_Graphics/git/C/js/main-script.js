//////////////////////
/* GLOBAL VARIABLES */
//////////////////////

var camera, cameras = [], scene, renderer, perspectiveCamera, controls;
var objects = [];

var geometry, mesh;
var wireframe_bool = false;

var slow = 0,  fast = 0;

var clock = new THREE.Clock(), delta = 1;

var house, ovni, subreiro;

var local_lights = [], olofote_light , direcional_light;

var size = 6;
var terrain;
var terrainSize = 1000; // Adjust the size of the terrain
var terrainHeight = -size*4; // Adjust the height of the terrain
var terrainResolution = 100; // Adjust the resolution of the terrain

var count = 0;

var trees = [];

var basic_phong_bool = false;


/////////////////////
/* CREATE SCENE(S) */
/////////////////////
function createScene() {
    'use strict';
  
    scene = new THREE.Scene();
  
    // Define the gradient colors
    var color1 = new THREE.Color(0x000022); // Starting color
    var color2 = new THREE.Color(0x000000); // Ending color
  
    // Create a gradient texture
    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    var gradient = context.createLinearGradient(0, 0, 0, window.innerHeight);
    gradient.addColorStop(0, color1.getStyle());
    gradient.addColorStop(1, color2.getStyle());
    context.fillStyle = gradient;
    context.fillRect(0, 0, window.innerWidth, window.innerHeight);
  
    // Create a texture from the gradient canvas
    var texture = new THREE.CanvasTexture(canvas);
  
    scene.background = texture;
  
    var axesHelper = new THREE.AxesHelper(10);
    axesHelper.visible = true;
    scene.add(axesHelper);
  
    createHouse(0,              -size * 4, 0, size);
    house.rotation.y = Math.PI/2 +  Math.random() * Math.PI/6;

    createOVNI(0,                size * 10, 0, 10);

    createSubreiro(size * 7 ,       -size * 3.5, size, size* 0.6); // front of house
    createSubreiro(-size * 6,       -size * 6, -size * 3.2, size * 1.2); // left back
    createSubreiro(size ,           -size * 5, size * 6, size*0.6); // right back
    createSubreiro(-size * 2,       -size * 6, -size * 9, size); // left left

    createSubreiro(size * 14 ,      -size * 2, size * 15.9, size* 0.6); 
    createSubreiro(-size * 20,      -size * 3, -size * 12.4, size * 1.2);
    createSubreiro(size * -12.3,    -size * 3, size * 13.7, size*0.6);
    createSubreiro(size * 8.6,      -size * 5, -size * 18.3, size);

    for (var i = 0; i < trees.length; i++) {
        trees[i].rotation.y = Math.random() * 2 * Math.PI;
    }

    var sky_distance = 599;

    var x = -600;
    var z = 100;
    var y = 200;
    var dist = 1 / Math.sqrt(x*x + y*y + z*z);
    x = x * dist * sky_distance;
    y = y * dist * sky_distance;
    z = z * dist * sky_distance;

    createMoon(x, y, z, size);
    // createTerrain();
    // createSkyDome();

    for (var i = 0; i < 1000; i++) {
        var x = Math.random() - 0.5;
        var z = Math.random() - 0.5;
        var y = Math.random();
        var dist = 1 / Math.sqrt(x*x + y*y + z*z);
        x = x * dist * sky_distance;
        y = y * dist * sky_distance;
        z = z * dist * sky_distance;

        // console.log("Star", x, y, z);
        createStar(x, y, z);
    }
  }
  

//////////////////////
/* CREATE CAMERA(S) */
//////////////////////
function createCamera() {
    'use strict';
    scene.positionY -= 50;
    
    var temp;
    
    temp = new THREE.StereoCamera();
    temp.aspect = window.innerWidth / window.innerHeight;
    // temp.eyeSep = 0.1;
    temp.cameraL.position.set(0, 200, 0);
    temp.cameraR.position.set(0, 200, 0);
    temp.cameraL.lookAt(scene.position);
    temp.cameraR.lookAt(scene.position);
    cameras.push(temp);

    
    temp = new THREE.PerspectiveCamera(70, window.innerWidth / window.innerHeight, 1, 1000);
    temp.position.set(150, 0, 0);
    temp.zoom = 0.5;
    temp.updateProjectionMatrix();
    temp.lookAt(scene.position);
    cameras.push(temp);

    // perspectiveCamera.position.set(0, 200, 0);
    
    temp = new THREE.OrthographicCamera(window.innerWidth / - 16, window.innerWidth / 16, window.innerHeight / 16, window.innerHeight / - 16, 1, 1000);
    temp.position.set(200, 200, 200);
    temp.zoom = 0.25;
    temp.updateProjectionMatrix();
    temp.lookAt(scene.position);
    cameras.push(temp);
    
    temp = new THREE.PerspectiveCamera(70, window.innerWidth / window.innerHeight, 1, 1000);
    temp.position.set(150, 150, 150);
    temp.lookAt(scene.position);
    cameras.push(temp);
    
    temp = new THREE.PerspectiveCamera(88, window.innerWidth / window.innerHeight, 1, 1000);
    temp.position.set(0, 200, 0);
    temp.zoom = 0.5;
    temp.updateProjectionMatrix();
    temp.lookAt(scene.position);
    cameras.push(temp);
    perspectiveCamera = temp;

    camera = temp;
}

/////////////////////
/* CREATE LIGHT(S) */
/////////////////////

////////////////////////
/* CREATE OBJECT3D(S) */
////////////////////////

function createBall(obj, material, x, y, z, size) {
    'use strict';

    geometry = new THREE.SphereGeometry( size/2, 16, 16 );
    mesh = new THREE.Mesh(geometry, material);
    
    mesh.position.set(x, y, z);
    obj.add(mesh);
    objects.push(mesh);
    
    return mesh;
}

function createCube(obj, material, x, y, z, sizeX, sizeY, sizeZ) {
    'use strict';

    geometry = new THREE.BoxGeometry( sizeX, sizeY, sizeZ );
    mesh = new THREE.Mesh(geometry, material);

    mesh.position.set(x, y, z);
    obj.add(mesh);
    objects.push(mesh);
}

function createCilinder(obj, material, x, y, z, diameter, height, rotation) {
    'use strict';

    var cilinder = new THREE.Object3D();
    cilinder.userData = { jumping: true, step: 0 };

    geometry = new THREE.CylinderGeometry(diameter/2, diameter/2, height/2, 16);
    cilinder.rotation.z = rotation;
    mesh = new THREE.Mesh(geometry, material);

    cilinder.add(mesh);
    cilinder.position.set(x, y + diameter/2, z);

    obj.add(cilinder);
    objects.push(mesh);

    return cilinder;
}

function createCone(obj, material, x, y, z, diameter, height, rotation) {
    'use strict';

    var cone = new THREE.Object3D();
    cone.userData = { jumping: true, step: 0 };

    geometry = new THREE.ConeGeometry(diameter/2, height/2, 16);
    if (rotation)
        cone.rotation.z = 0.5*Math.PI;
    mesh = new THREE.Mesh(geometry, material);

    cone.add(mesh);
    cone.position.set(x, y + diameter/2, z);

    obj.add(cone);
    objects.push(mesh);

    return cone;
}

function addWalls(obj, x, y, z, size) {
    'use strict';

    var window_height = size/2;

    const vertices = new Float32Array([
        // base
        -size*2.5       ,-size         ,-size,                          // down left away      0
        -size*2.5       ,-size         , size,                          // down left close     1
         size*2.5       ,-size         ,-size,                          // down right away     2
         size*2.5       ,-size         , size,                          // down right close    3

        // those who touch the roof
        -size*2.5       , size         ,-size,                          // up left away        4
        -size*2.5       , size         , size,                          // up left close       5
         size*2.5       , size         ,-size,                          // up right away       6
         size*2.5       , size         , size,                          // up right close      7
        
        // roof
         size*2.5       , size*1.5     , 0,                             // right               8
        -size*2.5       , size*1.5     , 0,                             // left                9

        // door frame
        -size*0.5       ,-size         , size,                          // down left           10
        -size*0.5       , size         , size,                          // up left             11
         size*0.5       ,-size         , size,                          // down right          12
         size*0.5       , size         , size,                          // up right            13

        // wall over the door
         size*0.5       , size*0.6   , size,                            // down left           14
        -size*0.5       , size*0.6   , size,                            // down right          15

        // right window
        1.5*size-size*0.35       ,-size*0.35   , size,                  // down left           16
        1.5*size+size*0.35       ,-size*0.35   , size,                  // down right          17
        1.5*size-size*0.35       , size*0.35   , size,                  // up left             18
        1.5*size+size*0.35       , size*0.35   , size,                  // up right            19

        // right window frame
        1.5*size-size*0.35       ,-size*1   , size,                     // down left           20
        1.5*size+size*0.35       ,-size*1   , size,                     // down right          21
        1.5*size-size*0.35       , size*1   , size,                     // down left           22
        1.5*size+size*0.35       , size*1   , size,                     // down right          23


        // left window
        -1.5*size-size*0.35       ,-size*0.35   , size,                 // down left           24
        -1.5*size+size*0.35       ,-size*0.35   , size,                 // down right          25
        -1.5*size-size*0.35       , size*0.35   , size,                 // up left             26
        -1.5*size+size*0.35       , size*0.35   , size,                 // up right            27

        // left window frame
        -1.5*size-size*0.35       ,-size*1   , size,                    // down left           28
        -1.5*size+size*0.35       ,-size*1   , size,                    // down right          29
        -1.5*size-size*0.35       , size*1   , size,                    // up left             30
        -1.5*size+size*0.35       , size*1   , size,                    // up right            31

    ]);
    
    const indices = [
        // left wall
        0, 1, 4,
        4, 1, 5,
        // left roof
        4, 5, 9,
        
        // right wall
        6, 3, 2,
        7, 3, 6,
        // right roof
        6, 8, 7,
        
        // back wall
        6, 2, 0,
        4, 6, 0,

        // front wall
            // door left
                // window right
                    10, 31, 29,
                    11, 31, 10,
                // window left
                    5, 1, 30,
                    1, 28, 30,
                // window top
                    31, 26, 27,
                    31, 30, 26,
                // window bottom
                    28, 29, 24,
                    29, 25, 24,
        
            // door right
                // window right
                    3, 23, 21,
                    7, 23, 3,
                // window left
                    13, 12, 22,
                    12, 20, 22,
                // window top
                    20, 21, 16,
                    16, 21, 17,
                // window bottom
                    23, 22, 18,
                    23, 18, 19,
            // door up
            15, 14, 13,
            15, 13, 11,

    ];

    geometry = new THREE.BufferGeometry();
    geometry.setAttribute( 'position', new THREE.BufferAttribute( vertices, 3 ) );
    geometry.setIndex( indices );
    geometry.computeVertexNormals();
    
    var material = new THREE.MeshPhongMaterial({ color: 0xffffff, wireframe: wireframe_bool });
    
    mesh = new THREE.Mesh(geometry, material);

    mesh.position.set(x, y, z);
    obj.add(mesh);
    objects.push(mesh);

    return mesh;
}

function addRoof(obj, x, y, z, size) {
    'use strict';

    const vertices2 = new Float32Array([
        // those who touch the roof
        -size*2.5       , size          , -size,
        -size*2.5       , size          , size,
        size*2.5        , size          , -size,
        size*2.5        , size          , size,

        // roof
        size*2.5            , size*1.5      , 0,
        -size*2.5           , size*1.5      , 0
    ]);

    const indices2 = [
        // front roof
        5, 1, 4,
        4, 1, 3,

        // back roof
        2, 0, 4,
        4, 0, 5,
        
    ];

    geometry = new THREE.BufferGeometry();
    geometry.setAttribute( 'position', new THREE.BufferAttribute( vertices2, 3 ) );
    geometry.setIndex( indices2 );
    geometry.computeVertexNormals();

    var material = new THREE.MeshPhongMaterial({ color: 0x662222, wireframe: wireframe_bool });
    mesh = new THREE.Mesh(geometry, material);

    mesh.position.set(x, y, z);
    obj.add(mesh);
    objects.push(mesh);

    return mesh;
}

function addWindow( obj, x, y, z, size ) {
    'use strict';

    const vertices3 = new Float32Array([
        // left window
        -size*1.5+size*0.35       ,-size*0.35   , size,                 // down left           0
        -size*1.5+size*0.35       , size*0.35   , size,                 // up left             1
        -size*1.5-size*0.35       ,-size*0.35   , size,                 // down left           2
        -size*1.5-size*0.35       , size*0.35   , size,                 // up left             3

        // right window
        size*1.5+size*0.35        ,-size*0.35   , size,                 // down right          4
        size*1.5+size*0.35        , size*0.35   , size,                 // up right            5
        size*1.5-size*0.35        ,-size*0.35   , size,                 // down right          6
        size*1.5-size*0.35        , size*0.35   , size,                 // up right            7

        // door
        +size*0.5       ,-size*1   , size,                              // down left           8
        +size*0.5       , size*0.6   , size,                            // up left             9
        -size*0.5       ,-size*1   , size,                              // down left           10
        -size*0.5       , size*0.6   , size,                            // up left             11
    ]);

    const indices3 = [
        // left window
        0, 1, 3,
        0, 3, 2,

        // right window
        4, 5, 7,
        4, 7, 6,

        // door
        8, 9, 11,
        8, 11, 10,
    ];

    geometry = new THREE.BufferGeometry();
    geometry.setAttribute( 'position', new THREE.BufferAttribute( vertices3, 3 ) );
    geometry.setIndex( indices3 );
    geometry.computeVertexNormals();

    var material = new THREE.MeshPhongMaterial({ color: 0xaaaaff, wireframe: wireframe_bool });

    mesh = new THREE.Mesh(geometry, material);
    
    mesh.position.set(x, y, z);
    obj.add(mesh);
    objects.push(mesh);

    return mesh;
}

function createHouse(x, y, z, size) {
    'use strict';

    house = new THREE.Object3D();
    
    addWalls(house, 0, 0, 0, size);
    addRoof(house, 0, 0, 0, size);
    addWindow(house, 0, 0, 0, size);

    house.position.set(x, y, z);
    scene.add(house);
}

function createOVNI(x, y, z, size) {
    'use strict';

    ovni = new THREE.Object3D();

    geometry = new THREE.SphereGeometry(size, 32, 32);

    var temp;
    
    var material = new THREE.MeshPhongMaterial({ color: 0xaaaaaa, wireframe: wireframe_bool });
    
    temp = createBall(ovni, material, 0, 0, 0, size*10);
    temp.scale.set(1, 0.375, 1);

    var material = new THREE.MeshPhongMaterial({ color: 0xaaaaff, wireframe: wireframe_bool });
    createBall(ovni, material, 0, size*1.25, 0, size*5, 32, 32);

    var material = new THREE.MeshPhongMaterial({ color: 0xdddd00, wireframe: wireframe_bool });
    
    for(var i = 0; i < 7; i++) {
        var parent = new THREE.Object3D();
        temp = createBall(parent, material, 0, -size*1.5, size*3, size, 32, 32);

        var light = new THREE.PointLight(0xdddd800);
        light.distance = 75;
        light.intensity = 1;
        light.rotation.set(0, 0, 0);
        parent.name = "local";
        light.name = "light";
        temp.add(light);

        parent.position.set(0, 0, 0);
        parent.rotation.y = i * 2 * Math.PI/7;

        ovni.add(parent);
        local_lights.push(parent);
    }

    olofote_light = createCilinder(ovni, material, 0, -size*3.25, 0, size*3, size, 0);
    olofote_light.name = "olofote_light";
    
    var light = new THREE.SpotLight(0xaaaaaa);
    light.intensity = 1;
    light.distance = 0;
    light.angle = Math.PI/16;
    light.penumbra = 0.25;
    light.name = "olofote";
    
    var target = new THREE.Object3D();
    target.position.set(0, -size*3, 0);
    olofote_light.add(target);
    light.target = target;
    
    olofote_light.add(light);

    ovni.position.set(x, y, z);
    ovni.rotation.x = Math.PI/128;
    scene.add(ovni);
}

function createSubreiro(x, y, z, size) {
    'use strict';

    subreiro = new THREE.Object3D();

    // geometry = new THREE.CylinderGeometry(size, size, size*2, 32);
    var material = new THREE.MeshPhongMaterial({ color: 0xa26a42, wireframe: wireframe_bool });


    // mesh = new THREE.Mesh(geometry, material);

    // mesh.position.set(x, y, z);
    // subreiro.add(mesh);
    // objects.push(mesh);
    createCilinder(subreiro, material, 0, 0, 0, size*0.8, size*9, Math.PI/16); //base
    createCilinder(subreiro, material, size*0.9, size*0.9, 0, size*0.5, size*5, Math.PI/16 - Math.PI/3); //ram0

    var material = new THREE.MeshPhongMaterial({ color: 0x47230a, wireframe: wireframe_bool });


    createCilinder(subreiro, material, size*1.4, size*1.3, 0, size*0.75, size * 2.3, Math.PI/16 - Math.PI/3); //cortiça ramo
    createCilinder(subreiro, material, -size*0.45, size*2, 0, size*1.25, size * 5.2, Math.PI/16); //cortiça base

    var temp;
    var material = new THREE.MeshPhongMaterial({ color: 0x004400, wireframe: wireframe_bool });
    temp = createBall(subreiro, material, size*1.8, size*2.2, 2, size*2.4);
    temp.scale.set(1, 0.5, 1);
    temp = createBall(subreiro, material, -size*0.6, size*3.4, 2, size*3.5);
    temp.scale.set(1, 0.5, 1);
    
    // var material = new THREE.MeshBasicMaterial({ color: 0x006400, wireframe: wireframe_bool });

    subreiro.position.set(x, y, z);
    scene.add(subreiro);
    trees.push(subreiro);
    return subreiro;
}

function createMoon(x, y, z, size) {
    'use strict';

    var moon = new THREE.Object3D();

    var material = new THREE.MeshPhongMaterial({ color: 0xaaaaaa, wireframe: wireframe_bool });
    var material = new THREE.MeshBasicMaterial({ color: 0x666666, wireframe: wireframe_bool });
    
    var temp = createBall(moon, material, 0, 0, 0, size*10, 32, 32);
    objects.pop();

    var dir_light = new THREE.DirectionalLight(0xffffff);
    dir_light.intensity = 1;
    dir_light.position.set(0, 0, 0);

    var ambient_light = new THREE.AmbientLight(0x333333);
    ambient_light.intensity = 1;
    temp.add(ambient_light);
    
    temp.add(dir_light);


    moon.position.set(x, y, z);
    scene.add(moon);
}

function createStar(x, y, z) {
    'use strict';

    var star = new THREE.Object3D();

    var material = new THREE.MeshPhongMaterial({ color: 0xffffff, wireframe: wireframe_bool });

    createBall(star, material, 0, 0, 0, size*0.5, 32, 32);

    // var dir_light = new THREE.DirectionalLight(0xffffff);
    // dir_light.intensity = 1;
    // dir_light.position.set(0, 0, 0);
    // temp.add(dir_light);

    // var ambient_light = new THREE.AmbientLight(0x333333);
    // ambient_light.intensity = 1;
    // temp.add(ambient_light);

    star.position.set(x, y, z);
    scene.add(star);
}

function createTerrain() {
    
    var loader = new THREE.TextureLoader();
    loader.load('https://cdn.discordapp.com/attachments/640620441291063306/1114231069714174013/heightmap.png', textureLoadCallback);
    
    function textureLoadCallback(texture) {
        var dims = 1500;
        var geometry = new THREE.PlaneGeometry(dims, dims, 100, 100);
        var image = texture.image;
        
        var canvas = Object.assign(document.createElement('canvas'), { height: 1081, width: 1081 });
        var context = Object.assign(canvas.getContext('2d'), { width: image.width, height: image.height });
        context.drawImage(image, 0, 0, image.width, image.height, 0, 0, context.width, context.height);
        var data = context.getImageData(0, 0, image.width, image.height).data;
        
        for (var i = 0; i < geometry.getAttribute('position').count; i++) {
            var u = geometry.getAttribute('uv').array[i * 2];
            var v = geometry.getAttribute('uv').array[i * 2 + 1];

            let col = Math.min(Math.floor(image.width * u), image.width - 1) * 4;
            let row = Math.min(Math.floor(image.height * v), image.height - 1) * 4;

            var k = row * image.width + col + 1;
            
            var y = data[k] / 255.0 * 255 - 55;
            var random = Math.random();

            var material;
            var color;
            if (random < 0.25)
                color = 0xdddd00;
            else if (random < 0.5)
                color = 0xccaacc;
            else if (random < 0.75)
                color = 0xaaddff;
            else
                color = 0xaaaaaa;
            
            material = new THREE.MeshPhongMaterial({ color: color, wireframe: wireframe_bool });
            
            var random = Math.random() - 0.5;
            if (Math.sqrt(Math.pow(u * dims - dims / 2, 2) + Math.pow(v * dims - dims / 2, 2)) < 650)
            createBall(scene, material, (u * dims - dims / 2) + random * 20, data[k] - 55,-( v * dims - dims / 2 ) + random * 20, 2.5);
            
            geometry.getAttribute('position').array[i * 3 + 2] = y;
        }
    
        var material = new THREE.MeshPhongMaterial({ color: 0x00ff00, map: texture, wireframe: wireframe_bool });
        var terrain = new THREE.Mesh(geometry, material);
        // console.log(terrain);
        terrain.rotation.x = Math.PI * 1.5;
    
        objects.push(terrain);
        scene.add(terrain);
    }


}

function createSkyDome() {
    // Create a sphere geometry for the skydome
    var skyGeometry = new THREE.SphereGeometry(600, 32, 32);
    
    // Load a sky texture
    // var textureLoader = new THREE.TextureLoader();
    // var skyTexture = textureLoader.load('sky_texture.jpg');

    // Create a material using the sky texture
    var loader = new THREE.TextureLoader();

    // loader.load('https://media.discordapp.net/attachments/640620441291063306/1114628833820278944/Z8PxBfXg0AfMcAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjMtMDYtMDNUMTg6NTY6MTMrMDA6MDDH94BOAAAAJXRF0AWHRkYXRlOm1vZGlmeQAyMDIzLTA2LTAzVDE4OjU2OjEzKzAwOjAwtqo48gAAAB50RVh0aWNjOmNv0AcHlyaWdodABHb29nbGUgSW5jLiAyMDE2rAszOAAAABR0RVh0aWNjOmRlc2NyaXB0aW9uAHNSR0K60AkHMHAAAAAElFTkSuQmCC.png?width=952&height=952', textureLoadCallback);
    loader.load('https://cdn.discordapp.com/attachments/762368964289757194/1114630344147210250/angryimg_1.png', textureLoadCallback);

    function textureLoadCallback(texture) {
        var material = new THREE.MeshPhongMaterial({color: 0x440044, map: texture, side: THREE.BackSide });

        // Create the skydome mesh
        var skydome = new THREE.Mesh(skyGeometry, material);
        
        skydome.rotation.x = Math.PI * 0.5;
        skydome.rotation.z = Math.PI * 1;
        objects.push(skydome);

        // Add the skydome to the scene
        scene.add(skydome);
        
        
    }
    
    // var skyMaterial = new THREE.MeshBasicMaterial({color: 0x000000, side: THREE.BackSide });

    // // Create the skydome mesh
    // var skydome = new THREE.Mesh(skyGeometry, skyMaterial);

    // // Add the skydome to the scene
    // scene.add(skydome);

}

//////////////////////
/* CHECK COLLISIONS */
//////////////////////
function checkCollisions(){
    'use strict';

}

///////////////////////
/* HANDLE COLLISIONS */
///////////////////////
function handleCollisions(){
    'use strict';

}

////////////
/* UPDATE */
////////////
function update(){
    'use strict';
    delta = clock.getDelta();
}

/////////////
/* DISPLAY */
/////////////
function render() {
    'use strict';
    animate();
    renderer.render(scene, camera);
}

////////////////////////////////
/* INITIALIZE ANIMATION CYCLE */
////////////////////////////////
function init() {
    'use strict';
    renderer = new THREE.WebGLRenderer({
        antialias: true
    });
    renderer.xr.enabled = true;
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);
    document.body.appendChild( VRButton.createButton( renderer ) );

    createScene();
    createCamera();

    controls = new THREE.OrbitControls(perspectiveCamera, renderer.domElement);
    controls.update();
    
    scene.traverse(function (node) {
        if (node instanceof THREE.AxesHelper) {
            node.visible = false;
        }
    });
    
    render();

    window.addEventListener("keydown", onKeyDown);
    window.addEventListener("keyup", onKeyUp);
    window.addEventListener("resize", onResize);
}

/////////////////////
/* ANIMATION CYCLE */
/////////////////////
function animate() {
    'use strict';

    // rotate ovni
    ovni.rotation.y += 0.01 * delta;
    count += 0.01 * delta;

    // ovni.position.x += Math.cos(count * 10) * 0.1;
    // ovni.position.z += Math.sin(count * 10) * 0.1;
    ovni.position.x += Math.cos(count * 10 ) * 0.1 + Math.random()-0.05 * 10;
    ovni.position.z += Math.sin(count * 10 ) * 0.1 + Math.random()-0.05 * 10;
    // ovni.position.y += Math.sin(count/2 + Math.PI/9) * 0.1;

    for(var i = 0; i < trees.length; i++){
        trees[i].rotation.x += (Math.cos(count) + (Math.random() - 0.5) * 10 ) * 0.001;
        trees[i].rotation.z += (Math.cos(count) + (Math.random() - 0.5) * 10 ) * 0.001;
    }

    // controls.update();
    // render();
    renderer.setAnimationLoop(render);
}
////////////////////////////
/* RESIZE WINDOW CALLBACK */
////////////////////////////
function onResize() {
    'use strict';

    renderer.setSize(window.innerWidth, window.innerHeight);

    if (window.innerHeight > 0 && window.innerWidth > 0) {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
    }

}

///////////////////////
/* KEY DOWN CALLBACK */
///////////////////////
function onKeyDown(e) {
    'use strict';

    switch (e.keyCode) {
    case 65: //A
    case 97: //a
        wireframe_bool = !wireframe_bool;
        for(var i = 0; i < objects.length; i++){
            objects[i].material.wireframe = wireframe_bool; 
        }
        break;
    
    case 49: //1
        createTerrain();
        break;
    case 50: //2
        createSkyDome();
        break;
    case 51: //3
        camera = cameras[4];
        break;
    case 52: //4
        camera = cameras[3];
        break;
    case 53: //5
        camera = cameras[2];
        break;
    case 54: //6
        camera = cameras[1];
        break;
    case 55: //7
        camera = cameras[0];
        break;
    
    // arrow
    case 37: //left
        ovni.position.x -= 10;
        break;
    case 38: //up
        ovni.position.z -= 10;
        break;
    case 39: //right
        ovni.position.x += 10;
        break;
    case 40: //down
        ovni.position.z += 10;
        break;


    case 83: //S
    case 115: //s
        if (ovni.children[9].children[2].intensity == 0)
            ovni.children[9].children[2].intensity = 1;
        else
            ovni.children[9].children[2].intensity = 0;
        break;
    case 80: //P
    case 112: //p
        if (ovni.children[3].children[0].children[0].intensity == 0)
            for(var i = 2; i < 9; i++){
                ovni.children[i].children[0].children[0].intensity = 1;
            }
        else
            for(var i = 2; i < 9; i++){
                ovni.children[i].children[0].children[0].intensity = 0;
            }
        break;
    
    case 81: //Q
    case 113: //q
    for(var i = 0; i < objects.length; i++){
        var color = objects[i].material.color;
        if (objects[i].material.map != undefined){
            var texture = objects[i].material.map;
            if(objects[i].material.side != undefined){
                var side = objects[i].material.side;
                var phong = new THREE.MeshLambertMaterial({color: color, wireframe: wireframe_bool, map: texture, side: side});
            }
            else {
                var phong = new THREE.MeshLambertMaterial({color: color, wireframe: wireframe_bool, map: texture});
            }
        }
        else {
            var phong = new THREE.MeshLambertMaterial({color: color, wireframe: wireframe_bool});
        }
        objects[i].material = phong;
    }
    break;
    case 87: //W
    case 119: //w
        for(var i = 0; i < objects.length; i++){
            var color = objects[i].material.color;
            if (objects[i].material.map != undefined){
                console.log(objects[i]);
                var texture = objects[i].material.map;
                if(objects[i].material.side != undefined){
                    var side = objects[i].material.side;
                    var phong = new THREE.MeshPhongMaterial({color: color, wireframe: wireframe_bool, map: texture, side: side});
                }
                else {
                    var phong = new THREE.MeshPhongMaterial({color: color, wireframe: wireframe_bool, map: texture});
                }
            }
            else {
                var phong = new THREE.MeshPhongMaterial({color: color, wireframe: wireframe_bool});
            }
            objects[i].material = phong;
        }
        break;

    case 69: //E
    case 101: //e
        for(var i = 0; i < objects.length; i++){
            var color = objects[i].material.color;
            if (objects[i].material.map != undefined){
                var texture = objects[i].material.map;
                if(objects[i].material.side != undefined){
                    var side = objects[i].material.side;
                    var basic = new THREE.MeshToonMaterial({color: color, wireframe: wireframe_bool, map: texture, side: side});
                }
                else {
                    var basic = new THREE.MeshToonMaterial({color: color, wireframe: wireframe_bool, map: texture});
                }
            }
            else {
                var basic = new THREE.MeshToonMaterial({color: color, wireframe: wireframe_bool});
            }
            objects[i].material = basic;
        }
        break;
        
    case 82: //R
    case 114: //r
        for(var i = 0; i < objects.length; i++){
            var color = objects[i].material.color;
            if (objects[i].material.map != undefined){
                var texture = objects[i].material.map;
                if(objects[i].material.side != undefined){
                    var side = objects[i].material.side;
                    var basic = new THREE.MeshBasicMaterial({color: color, wireframe: wireframe_bool, map: texture, side: side});
                }
                else {
                    var basic = new THREE.MeshBasicMaterial({color: color, wireframe: wireframe_bool, map: texture});
                }
            }
            else {
                var basic = new THREE.MeshBasicMaterial({color: color, wireframe: wireframe_bool});
            }
            objects[i].material = basic;
        }
        break;


    case 76: //L
    case 108: //l
        camera = perspectiveCamera;
        break;
    }
}

///////////////////////
/* KEY UP CALLBACK */
///////////////////////
function onKeyUp(e){
    'use strict';

}