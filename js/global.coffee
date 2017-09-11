$ ->
  document.getElementById('loading').className = 'show'

  graphics = new Graphics()
  return

class Graphics
  constructor: ->
    @settings = 
      camera_x: 0,
      camera_y: 500,
      camera_z: 1800,
      half_screen_x: window.innerWidth/2,
      half_screen_y: window.innerHeight/2,
      lookat_point: new THREE.Vector3(-1000,300,0)
    
    @scene = new THREE.Scene()
    @camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 )
    @camera.position.x = @settings.camera_x
    @camera.position.y = @settings.camera_y
    @camera.position.z = @settings.camera_z

    @loadModel( '3d/pien.json', 'textures/branch_baked.jpg' )
    for i in [1..10]
      @loadModel( '3d/m'+i+'.json', 'textures/m'+i+'.png' )

    light = new THREE.DirectionalLight( 0xffffff, 0.1 )
    @scene.add( light )

    if Detector.webgl then @renderer= new THREE.WebGLRenderer() else @renderer= new THREE.CanvasRenderer()
    @renderer.setSize( window.innerWidth, window.innerHeight )
    @renderer.setClearColor( 0xffffff, 0)

    @clock = new THREE.Clock()

    @controls = new THREE.OrbitControls( @camera, @renderer.domElement )
    @controls.autoRotate = true
    @controls.rotateSpeed = 0.01
    @controls.target = new THREE.Vector3(0, 300, 0) 
    @controls.mouseButtons = {  }
    @controls.enableZoom = false
    @controls.enableRotate = false
    @controls.enablePan = false

    document.body.appendChild( @renderer.domElement )

    setTimeout =>
      @renderer.domElement.className = 'show'
    , 500

    window.addEventListener 'resize', =>
      @resize()
    , false
/
    @render()
    return

  render: =>
    requestAnimationFrame @render

    delta = @clock.getDelta()
    @controls.update(delta)

    @renderer.render( @scene, @camera )
    return

  resize: =>
    @renderer.setSize( window.innerWidth, window.innerHeight )
    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.updateProjectionMatrix()

    @settings.half_screen_x = window.innerWidth/2
    @settings.half_screen_y = window.innerHeight/2
    return

  loadModel: (src, texture_src) =>
    loader = new THREE.BufferGeometryLoader()
		
    loader.load src, ( geometry ) =>
      texture_loader = new THREE.TextureLoader()
			
      texture_loader.load texture_src, ( texture ) =>
        material = new THREE.MeshBasicMaterial({map: texture, overdraw: 0.5})
        object = new THREE.Mesh( geometry, material )
        object.scale.set(200,200,200)
        object.position.z = 100
        @scene.add( object )
        return
      return
    return 






