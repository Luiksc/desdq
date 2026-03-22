extends Button

var dio=Dialog.new()
var dialog:=dio.start(self)



	
func talk():
	
	dialog.say("Hello there ? ") #add the char name at the end to customize the color of the text and how the npc name  
	dialog.say("my name is AL what is your name? ")
	var user_name=await dialog.input("name?") #must use await if you are getting an imput
	dialog.say("hello "+user_name+" nice to meet you")
	dialog.say("I have a question for you")
	dialog.menu("do you like apples?", {
			"Yes": "yes_function",
			"No": "No_function",
		}) # the first part is the function name it must match
	

func yes_function():
	dialog.say("greate here you go have one")
	dialog.action("take_apple") #trigger other function in your code to do something
	dialog.voice("res://addons/dialog_system/coin.mp3")#audio plays at this point
	dialog.say("check console")

func No_function():
	dialog.say("I would have given you one")
func _on_pressed() -> void:
	talk()

func take_apple():
	print("Apple Added to your inventory ")
