# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  onResize = ->
    outsideSize = getSize($container.parent()[0]).innerWidth
    cols = Math.floor(outsideSize / (columnWidth))

    # set container width to columns
    if cols != 1
      $container.width cols * columnWidth - gutter
    else
      $container.width cols * columnWidth

    # manually trigger layout
    $container.packery()
    return

  $container = $(".packery")
  # initialize Packery after all images have loaded
  $container.imagesLoaded ->
    $container.packery
      itemSelector: ".item"
      transitionDuration: "0.8s"
      columnWidth: 300
      gutter: 20
      isResizeBound: false

    return
  pckry = $container
  gutter = 20 or 0
  columnWidth = 320

  # debounce resize event
  resizeTimeout = undefined
  $(window).on "resize", ->
    clearTimeout resizeTimeout  if resizeTimeout
    resizeTimeout = setTimeout(onResize, 100)
    return


  # initial trigger
  onResize()
  return
