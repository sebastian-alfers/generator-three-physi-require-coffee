require({
  baseUrl: 'js',
  // three.js should have UMD support soon, but it currently does not
  shim: { 'vendor/three': { exports: 'THREE' } }
}, [
'vendor/three'
], function(THREE) {

  require(['vendor/physi', 'vendor/physijs_worker', 'vendor/stats.min'], function(a,b,c){


    var stats = new Stats();
    stats.setMode(1); // 0: fps, 1: ms

    // align top-left
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.left = '0px';
    stats.domElement.style.top = '0px';
    document.body.appendChild( stats.domElement );


    var camera, scene, renderer;
    var geometry, material, mesh;

    boot();

    /*
    function box() {
    return false;
  }
  */

  function init() {

    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
    camera.position.z = 1000;

    scene = new THREE.Scene();

    geometry = new THREE.CubeGeometry(200, 200, 200);
    material = new THREE.MeshBasicMaterial({
      color: 0xff0000,
      wireframe: true
    });

    mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);


    renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);

    document.body.appendChild(renderer.domElement);

  }

  function boot() {
    if (window.WebGLRenderingContext) {
      init();
      animate();
    }
    else {
      alert('no WEbGL :( ');
      return false;
    }
  }

  function animate() {

    //stats.begin();


    mesh.rotation.x += 0.01;
    mesh.rotation.y += 0.02;

    renderer.render(scene, camera);


    //stats.end();

    requestAnimationFrame(animate);

  }



});

});
