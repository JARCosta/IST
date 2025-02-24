/*global THREE, requestAnimationFrame, console*/

var camera, scene, renderer;

var geometry, material, mesh;

var ball, toro;

function addTableLeg(obj, x, y, z, size) {
    'use strict';

    geometry = new THREE.CubeGeometry(2 * size, 6 * size, 2 * size);
    mesh = new THREE.Mesh(geometry, material);
    mesh.position.set(x, y - 3, z);
    obj.add(mesh);
}

function addTableTop(obj, x, y, z, size) {
    'use strict';
    geometry = new THREE.CubeGeometry(60 * size, 2 * size, 20 * size);
    // (width, height, depth)
    mesh = new THREE.Mesh(geometry, material);
    mesh.position.set(x, y, z);
    obj.add(mesh);
}


function createTable(x, y, z, size) {
    'use strict';

    var table = new THREE.Object3D();

    material = new THREE.MeshBasicMaterial({ color: 0x00ff00, wireframe: true });

    addTableTop(table, 0, 0, 0, size);
    addTableLeg(table, -25, -1, -8, size);
    addTableLeg(table, -25, -1, 8, size);
    addTableLeg(table, 25, -1, 8, size);
    addTableLeg(table, 25, -1, -8, size);

    scene.add(table);

    table.position.x = x;
    table.position.y = y;
    table.position.z = z;
}

function createBall(x, y, z, size) {
    'use strict';

    ball = new THREE.Object3D();
    ball.userData = { jumping: true, step: 0 };

    material = new THREE.MeshBasicMaterial({ color: 0xff0000, wireframe: true });
    geometry = new THREE.SphereGeometry(4 * size, 10, 10);
    // (ratio, widthSegments, heightSegments)
    mesh = new THREE.Mesh(geometry, material);

    ball.add(mesh);
    ball.position.set(x, y, z);

    scene.add(ball);
}

function createToro(x,y,z, size) {
    'use strict';

    toro = new THREE.Object3D();
    toro.userData = { jumping: true, step: 0 };

    material = new THREE.MeshBasicMaterial({ color: 0xffffff, wireframe: true });
    geometry = new THREE.TorusGeometry( 10 * size, 3 * size, 16, 100 );
    mesh = new THREE.Mesh(geometry, material);

    toro.add(mesh);
    toro.position.set(x, y, z);
    toro.rotation.x = Math.PI / 2 + (Math.PI)/10;
    toro.rotation.z = Math.PI / 2;


    scene.add(toro);
}

function createCone(x,y,z, size) {
    'use strict';

    var cone = new THREE.Object3D();
    cone.userData = { jumping: true, step: 0 };

    material = new THREE.MeshBasicMaterial({ color: 0xffffff, wireframe: true });
    geometry = new THREE.ConeGeometry( 5 * size, 20 * size, 32 );
    mesh = new THREE.Mesh(geometry, material);

    cone.add(mesh);
    cone.position.set(x, y, z);
    cone.rotation.x = Math.PI / 2 + (Math.PI)/10;
    cone.rotation.z = Math.PI / 2;


    scene.add(cone);
}

function createScene() {
    'use strict';

    scene = new THREE.Scene();


    scene.add(new THREE.AxisHelper(10));

    
    // createTable(0, 0, 0, 1);
    createToro(0, 0, 0, 3.5);
    // createBall(0, 0, 15, 1);
    createCone(0, 0, 15, 1);
}

function createCamera() {
    'use strict';
    camera = new THREE.PerspectiveCamera(70,
                                         window.innerWidth / window.innerHeight,
                                         1,
                                         1000);
    camera.position.x = 50;
    camera.position.y = 50;
    camera.position.z = 50;
    camera.lookAt(scene.position);
}

function onResize() {
    'use strict';

    renderer.setSize(window.innerWidth, window.innerHeight);

    if (window.innerHeight > 0 && window.innerWidth > 0) {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
    }

}

function onKeyDown(e) {
    'use strict';

    switch (e.keyCode) {
    case 65: //A
    case 97: //a
        scene.traverse(function (node) {
            if (node instanceof THREE.Mesh) {
                node.material.wireframe = !node.material.wireframe;
            }
        });
        break;
    case 83:  //S
    case 115: //s
        ball.userData.jumping = !ball.userData.jumping;
        toro.userData.jumping = !toro.userData.jumping;
        break;
    case 69:  //E
    case 101: //e
        scene.traverse(function (node) {
            if (node instanceof THREE.AxisHelper) {
                node.visible = !node.visible;
            }
        });
        break;
    }
}

function render() {
    'use strict';
    renderer.render(scene, camera);
}

function init() {
    'use strict';
    renderer = new THREE.WebGLRenderer({
        antialias: true
    });
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    createScene();
    createCamera();
    
    scene.traverse(function (node) {
        if (node instanceof THREE.AxisHelper) {
            node.visible = false;
        }
    });
    
    render();

    window.addEventListener("keydown", onKeyDown);
    window.addEventListener("resize", onResize);
}

function animate() {
    'use strict';



    // if (ball.userData.jumping) {
    //     ball.userData.step += 0.1416;
    //     ball.position.y = Math.abs(30 * (Math.sin(ball.userData.step)));
    //     ball.position.z = -15 * ball.userData.step
    //     ball.position.z = -15 * (Math.cos(ball.userData.step));
    // }
    if (toro.userData.jumping) {
        
        toro.userData.step += 0.1416 * 0.5;
        var cos = Math.cos(toro.userData.step);
        var sin = Math.sin(toro.userData.step);
        toro.rotation.x = Math.PI/2 + (Math.PI * cos)/10;
        toro.rotation.z = toro.userData.step;
        toro.rotation.y = Math.PI + (Math.PI * sin)/10;

    }
    render();

    requestAnimationFrame(animate);
}
