### Godot Button Theme Generator

# What the tool generates
- This tool generates button themes for Godot.

# How to run the tool
- IMPORTANT: IF THERE IS NO themes folder, create one
- To run the tool, play main.tscn and click on the button that says "This Button Changes Those Buttons!"
- Mess around with the sliders and toggles to influence the generation towards different types of buttons.
- If you find a button that you like, click on it.  That will change the themes of the buttons on the right.
- If you like it, click "Save button theme" and check the themes folder.  
- Now you have a button theme that you can drag into any other Button node in any other Godot project!

# Parameter Explanations
- Warmness / Coolness: Influences the color of the button by making it closer to red-ish (warm) & blue-ish (cool)
- Sharpness / Smoothness: Influences the border generation to make the edges more rounded or straight lines
- Skew toggle: Toggles whether the buttons are skewed (slanted) or not.  If on, buttons are skewed by a range of 0-5

# Example Outputs
- Check example_output folder

# Known Limitations
- This generator is unable to generate buttons with gradients or patterns.
- The button names that are generated aren't great.  They can sometimes conflict and override each other and will sometimes get the wrong color.
- As of now, this generator is limited to only being run in Godot.  I would've liked to have it on itch.io, but I couldn't figure out downloading files..
