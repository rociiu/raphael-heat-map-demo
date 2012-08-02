class RaphaelMap.MapView extends Backbone.View

  initialize: (opts)->
    @data = opts.data
    @el = opts.el
    @worldmap = window.worldmap

  render: ->
    paper = new Raphael(@el, 1000, 750)
    paper.rect(0, 0, 1000, 750, 10).attr({stroke: 'none', fill: '#fff'})
    paper.text(20, 20, "Chrome Browser Percentage World").attr({'text-anchor': 'start', 'font-size': '20px'})

    paper.setStart()
    _.each _.keys(@worldmap.shapes), (country_iso_code)=>
      path = paper.path(@worldmap.shapes[country_iso_code]).attr({stroke: "#fff", fill: @colorOfCountry(country_iso_code), "stroke-opacity": 0.25})
      @bindHoverToCountry(paper, country_iso_code, path)
    world = paper.setFinish()
    world.transform("t0, 80")

    @drawBars(paper)
      
  drawBars: (paper)->
    x = 840
    _.each @colorsRange().reverse(), (range)->
      paper.rect(x, 500, 50, 25).attr({fill: range.color, stroke: 'none'})
      paper.text(x + 25, 490, "#{range.min}-#{range.max}").attr({'text-anchor': 'center'})
      x = x - 10 - 50

  bindHoverToCountry: (paper, country_iso_code, path)->
    that = this
    path.hover(
      (e)->
        name = that.worldmap.names[country_iso_code]
        desc = "#{that.data[name]} %"
        this.tipSet = that.drawCountryTooltip(paper, e.offsetX, e.offsetY, name, desc)
        this.c = this.c || this.attr("fill")
        this.stop().animate({fill: "#C13A27"}, 500)
      (e)->
        this.tipSet.remove()
        this.stop().animate({fill: this.c}, 500)
    )

  drawCountryTooltip: (paper, offsetX, offsetY, name, desc)->
    tipSet = paper.set()
    strWidth = _.max([name.length, desc.length])
    rectWidth = parseInt(strWidth * 220) / 33 + 10
    rectWidth = _.max([rectWidth, 80])
    if (1000 - offsetX) < rectWidth
      x = 1000 - rectWidth
    else
      x = offsetX
    y = offsetY
    rectHeight = 48
    rectRadius = 3
    tipSet.push paper.rect(x, y, rectWidth, rectHeight, rectRadius).attr({fill: '#fff', 'fill-opacity': 0.7, stroke: '#D9DADA'})
    tipSet.push paper.text(x + 10, y + 15, name).attr({'text-anchor': 'start', 'font-size': '13px'})
    tipSet.push paper.text(x + 10, y + 35, desc).attr({'text-anchor': 'start', 'font-size': '13px'})
    tipSet

  colorOfCountry: (iso_code)->
    country_name = @worldmap.names[iso_code]
    value = @data[country_name]
    if value?
      @colorOfValue(value)
    else
      '#EAE5DE'

  colorOfValue: (value)->
    value = parseFloat(value)
    color = '#EAE5DE'
    _.each @colorsRange(), (range)->
      if range.min < value && value < range.max
        color = range.color
    color

  colorsRange: ->
    [
      {min: 0, max: 1, color: '#EBEDDA'}
      {min: 1, max: 24, color: '#D6DBB3'}
      {min: 24, max: 49, color: '#949D48'}
      {min: 49, max: 74, color: '#6E7537'}
      {min: 74, max: 100, color: '#494F23'}
    ]

