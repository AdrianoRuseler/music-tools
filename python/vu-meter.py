from PIL import Image, ImageDraw, ImageFont

# Settings
width, height = 600, 150
bar_height = 30
margin = 20
ticks = [-20,-15,-10, -5,0, 2]
colors = ["green", "yellow", "orange", "red", "deeppink"]

# Simulated dB values for left and right channels
left_db = 2
right_db = -5

def db_to_x(db):
    """Convert dB value to x-coordinate on the meter"""
    return int((db + 20) / 30 * (width - 2 * margin))

# Create image
img = Image.new("RGB", (width, height), "black")
draw = ImageDraw.Draw(img)
font = ImageFont.load_default()

# Draw scale ticks
for db in ticks:
    x = db_to_x(db)
    draw.line([(x, margin), (x, margin + bar_height * 2 + 10)], fill="white")
    draw.text((x - 10, margin + bar_height * 2 + 15), f"{db}dB", fill="white", font=font)

# Draw labels
draw.text((margin, margin - 15), "LEFT", fill="white", font=font)
draw.text((margin, margin + bar_height + 5), "RIGHT", fill="white", font=font)

# Draw bars
def draw_bar(y_offset, db_value):
    x_end = db_to_x(db_value)
    for i in range(margin, x_end, 10):
        color_index = min((i - margin) // ((width - 2 * margin) // len(colors)), len(colors) - 1)
        draw.rectangle([i, y_offset, i + 8, y_offset + bar_height], fill=colors[color_index])

draw_bar(margin, left_db)
draw_bar(margin + bar_height + 10, right_db)

# Save image
img.save("vu_meter.png")
