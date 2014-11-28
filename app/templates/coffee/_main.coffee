# inspired by:
# * http://chandlerprall.github.io/Physijs/
#
require ["/js/vendor/three.js"], (aa) ->
  require [
    "/js/vendor/physi.js"
    "/js/vendor/stats.min.js"
  ], (a, b, c, d) ->
    Physijs.scripts.worker = "/js/vendor/physijs_worker.js"
    Physijs.scripts.ammo = "/js/vendor/ammo.js"
    initScene = undefined
    render = undefined
    _boxes = []
    spawnBox = undefined
    renderer = undefined
    render_stats = undefined
    physics_stats = undefined
    scene = undefined
    ground_material = undefined
    ground = undefined
    light = undefined
    camera = undefined
    boxA = undefined
    boxB = undefined
    initScene = ->
      renderer = new THREE.WebGLRenderer(antialias: true)
      renderer.setSize window.innerWidth, window.innerHeight
      renderer.shadowMapEnabled = true
      renderer.shadowMapSoft = true
      document.getElementById("viewport").appendChild renderer.domElement
      render_stats = new Stats()
      render_stats.domElement.style.position = "absolute"
      render_stats.domElement.style.top = "0px"
      render_stats.domElement.style.zIndex = 100
      document.getElementById("viewport").appendChild render_stats.domElement
      physics_stats = new Stats()
      physics_stats.domElement.style.position = "absolute"
      physics_stats.domElement.style.top = "50px"
      physics_stats.domElement.style.zIndex = 100
      document.getElementById("viewport").appendChild physics_stats.domElement
      scene = new Physijs.Scene
      scene.setGravity new THREE.Vector3(0, -30, 0)
      scene.addEventListener "update", ->
        scene.simulate `undefined`, 1
        physics_stats.update()
        return

      camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 1000)
      camera.position.set 60, 50, 60
      camera.lookAt scene.position
      scene.add camera

      # Light
      light = new THREE.DirectionalLight(0xffffff)
      light.position.set 20, 40, -15
      light.target.position.copy scene.position
      light.castShadow = true
      light.shadowCameraLeft = -60
      light.shadowCameraTop = -60
      light.shadowCameraRight = 60
      light.shadowCameraBottom = 60
      light.shadowCameraNear = 20
      light.shadowCameraFar = 200
      light.shadowBias = -.0001
      light.shadowMapWidth = light.shadowMapHeight = 2048
      light.shadowDarkness = .7
      scene.add light

      ground_material = new THREE.MeshBasicMaterial(color: 0x00ff00)
      ground = new Physijs.BoxMesh(new THREE.CubeGeometry(100, 1, 100), ground_material, 0) # mass
      ground.receiveShadow = true
      scene.add ground
      boxA = spawnBox(boxA)
      boxB = spawnBox(boxB)
      requestAnimationFrame render
      scene.simulate()
      return

    #end initScene()
    spawnBox = ->
      box_geometry = new THREE.CubeGeometry(20, 2, 20)
      handleCollision = (collided_with, linearVelocity, angularVelocity) ->
        console.log "collision"

      createBox = (boxObj) ->
        material = new THREE.MeshBasicMaterial(color: 0xff0000)
        boxObj = new Physijs.BoxMesh(box_geometry, material)
        boxObj.position.set Math.random() * 15 - 7.5, 5, Math.random() * 15 - 7.5
        boxObj.castShadow = true
        boxObj.addEventListener "ready", ->
          console.log "ready"

        boxObj.addEventListener "collision", handleCollision
        scene.add boxObj
        boxObj

      createBox()

    # end spawn box
    speed = 0.7
    boxAChange = speed
    boxBChange = -speed
    limit = 50
    render = ->
      boxAChange = -speed  if boxA.position.z > limit
      boxAChange = speed  if boxA.position.z < -limit
      boxBChange = -speed  if boxB.position.z > limit
      boxBChange = speed  if boxB.position.z < -limit
      boxA.__dirtyPosition = true
      boxA.position.z += boxAChange
      boxB.__dirtyPosition = true
      boxB.position.z += boxBChange
      requestAnimationFrame render
      renderer.render scene, camera
      render_stats.update()
      return

    initScene()
    return

  return
