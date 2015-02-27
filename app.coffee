bg = new BackgroundLayer
	backgroundColor: "white"
	
ITEMS = [
	"one"
	"two"
	"three"
	"four"
	"five"
	"six"
	"seven"
	"eight"
	"nine"
	"ten"
	"eleven"
	"twelve"
	"thirteen"
	"fourteen"
]


GUTTER = 10
ITEM_HEIGHT = 100

container = new Layer
	width: 600
	height: 1000
	backgroundColor: "rgba(0,0,0,0)"

container.centerX()
container.centerY()

container.scroll = true

list = new Layer
	width: 600
	height: (ITEM_HEIGHT + GUTTER) * ITEMS.length
	backgroundColor: "rgba(0,0,0,0)"
	superLayer: container

list.centerX()

toBottom = (itemAtPos, items) ->
	moving = items.filter (item) ->
		item.pos is itemAtPos
	moving = moving[0]
	
	toShift = items.filter (item) ->
		item.pos > itemAtPos
	
	toShift.forEach (item) ->
		item.pos--
		item.item.updatePos(item.pos)
		item.item.move()
	
	console.log(moving)
	moving.pos = ITEMS.length - 1
	moving.item.updatePos(moving.pos)
	moving.item.move()
	
toTop = (itemAtPos, items) ->
	moving = items.filter (item) ->
		item.pos is itemAtPos
	moving = moving[0]
	
	toShift = items.filter (item) ->
		item.pos < itemAtPos
	
	toShift.forEach (item) ->
		item.pos++
		item.item.updatePos(item.pos)
		item.item.move()
	
	moving.pos = 0
	moving.item.updatePos(moving.pos)
	moving.item.move()
	
	

listItem = (text, index) ->
	item = new Layer
		y: index * (ITEM_HEIGHT + GUTTER)
		width: 500
		height: 100
		backgroundColor: "rgba(0,0,0,0)"
		superLayer: list
		shadowColor: "rgba(0,0,0, 0.2)"
	
	item.style = 
		"border": "5px solid grey"
		"color": "black"
		"textAlign": "center"
		"padding": "1em"
		
	item.centerX()
	
	item.index = index
	item.pos = index * (ITEM_HEIGHT + GUTTER)
	
	item.updatePos = (i) ->
		item.pos = i * (ITEM_HEIGHT + GUTTER)
		item.index = i
		
	item.move = ->
		item.animate
			properties:
				y: this.pos
			time: 0.5
			curve: "ease"
	
	item.html = text
	
	item.draggable.enabled = true
	
	item.states.add
		dragging:
			shadowY: 17
			shadowBlur: 30
			shadowColor: "rgba(0,0,0, 0.22)"
			
	
	item.on Events.DragStart, ->
		item.previousY = item.y
		item.states.switch("dragging")
	
	item.on Events.DragEnd, ->
		item.centerX()
		if item.y > item.previousY
			toBottom(item.index, items)
		else
			toTop(item.index, items)
		item.states.switch("default")
	
	item
		
items = ITEMS.map (item, index) ->
	{pos: index, item: 	listItem(item, index)}
	
