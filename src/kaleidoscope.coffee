# Kaleidoscope
  
class Kaleidoscope
  
  HALF_PI: Math.PI / 2
  TWO_PI: Math.PI * 2
  
  constructor: ( @options = {} ) ->
    
    @defaults =
      offsetRotation: 0.0
      offsetScale: 1.0
      offsetX: 0.0
      offsetY: 0.0
      radius: 800
      slices: 12
      zoom: .4
        
    @[ key ] = val for key, val of @defaults
    @[ key ] = val for key, val of @options
      
    @domElement ?= document.createElement 'canvas'
    @context ?= @domElement.getContext '2d'
    @image ?= document.createElement 'img'
    
  draw: ->
    # console.log(@radius * 2)
    @domElement.width = @domElement.height = @radius * 2
    @context.fillStyle = @context.createPattern @image, 'repeat'
    
    scale = @zoom * ( @radius / Math.min @image.width, @image.height )
    step = @TWO_PI / @slices
    cx = @image.width / 2

    for index in [ 0..@slices ]
      
      @context.save()
      @context.translate @radius, @radius
      @context.rotate index * step
      
      @context.beginPath()
      @context.moveTo -0.5, -0.5
      @context.arc 0, 0, @radius, step * -0.51, step * 0.51
      @context.lineTo 0.5, 0.5
      @context.closePath()
      
      @context.rotate @HALF_PI
      @context.scale scale, scale
      @context.scale [-1,1][index % 2], 1
      @context.translate @offsetX - cx, @offsetY
      @context.rotate @offsetRotation
      @context.scale @offsetScale, @offsetScale

      # @context.rect(80,80,80,80);
      # @context.clip()
      
      @context.fill()

      @context.restore()

# Drag & Drop
  
class DragDrop
  
  constructor: ( @callback, @context = document, @filter = /^image/i ) ->
    
    disable = ( event ) ->
      do event.stopPropagation
      do event.preventDefault
    
    @context.addEventListener 'dragleave', disable
    @context.addEventListener 'dragenter', disable
    @context.addEventListener 'dragover', disable
    @context.addEventListener 'drop', @onDrop, no
      
  onDrop: ( event ) =>
    
    do event.stopPropagation
    do event.preventDefault
      
    file = event.dataTransfer.files[0]
    
    if @filter.test file.type
      
      reader = new FileReader
      reader.onload = ( event ) => @callback? event.target.result
      reader.readAsDataURL file

# Init kaleidoscope
  
image = new Image
image.onload = => do kaleidoscope.draw
image.src = 'img/tree.jpg'

kaleidoscope = new Kaleidoscope
  image: image
  slices: 20

kaleidoscope.domElement.style.position = 'absolute'
kaleidoscope.domElement.style.marginLeft = -kaleidoscope.radius + 'px'
kaleidoscope.domElement.style.marginTop = -kaleidoscope.radius + 'px'
kaleidoscope.domElement.style.left = '50%'
kaleidoscope.domElement.style.top = '50%'
kaleidoscope.domElement.setAttribute('class','kaleidoscope')
document.body.appendChild kaleidoscope.domElement
  
# Init drag & drop

dragger = new DragDrop ( data ) -> kaleidoscope.image.src = data
  
# Mouse events
  
tx = kaleidoscope.offsetX
ty = kaleidoscope.offsetY
tr = kaleidoscope.offsetRotation
  
onMouseMoved = ( event ) =>

  cx = window.innerWidth / 2
  cy = window.innerHeight / 2
                
  dx = event.pageX / window.innerWidth
  dy = event.pageY / window.innerHeight
                
  hx = dx - 0.5
  hy = dy - 0.5
                
  tx = hx * kaleidoscope.radius * -2
  ty = hy * kaleidoscope.radius * 2
  tr = Math.atan2 hy, hx

window.addEventListener 'mousemove', onMouseMoved, no
                
# Init
  
options =
  interactive: yes
  ease: 0.1
                
do update = =>
                
  if options.interactive

    delta = tr - kaleidoscope.offsetRotation
    theta = Math.atan2( Math.sin( delta ), Math.cos( delta ) )
                
    kaleidoscope.offsetX += ( tx - kaleidoscope.offsetX ) * options.ease
    kaleidoscope.offsetY += ( ty - kaleidoscope.offsetY ) * options.ease
    kaleidoscope.offsetRotation += ( theta - kaleidoscope.offsetRotation ) * options.ease
    
    do kaleidoscope.draw
  
  setTimeout update, 1000/60

onChange = =>

  kaleidoscope.domElement.style.marginLeft = -kaleidoscope.radius + 'px'
  kaleidoscope.domElement.style.marginTop = -kaleidoscope.radius + 'px'
    
  options.interactive = no
    
  do kaleidoscope.draw

# ( c.onChange onChange unless c.property is 'interactive' ) for c in gui.__controllers
