
local button = null;

addCommandHandler("createGUI",function(pid)
{
	if (!button) {
		button = guiCreateElement(ELEMENT_TYPE_BUTTON, "Hello World", 500, 500, 100, 35);

		sendMessage("ELement created");
	}
});

addCommandHandler("destroyGUI", function(pid)
{
	if (button) {
		guiDestroyElement(button);
		button = null;

		sendMessage("Element destroyed");
	}
});

addasdaw

// eof
