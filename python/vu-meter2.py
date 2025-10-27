import matplotlib.pyplot as plt
import numpy as np

def create_vu_meter_scale(filename="vu_meter_scale.png"):
    fig, ax = plt.subplots(figsize=(10, 4))

    # Background for the meter
    ax.set_facecolor('lightgoldenrodyellow')
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_visible(False)

    # Disable axis ticks and labels
    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_xticklabels([])
    ax.set_yticklabels([])

    # Arc for the scale
    center_x, center_y = 0.5, -0.2
    radius = 1.0

    # Angles for the scale (adjust these to match a realistic VU meter arc)
    start_angle_deg = 210  # Roughly -20 dB
    end_angle_deg = 330    # Roughly +4 dB (clipping zone)

    start_angle_rad = np.deg2rad(start_angle_deg)
    end_angle_rad = np.deg2rad(end_angle_deg)

    theta = np.linspace(start_angle_rad, end_angle_rad, 500)
    x_arc = center_x + radius * np.cos(theta)
    y_arc = center_y + radius * np.sin(theta)
    ax.plot(x_arc, y_arc, color='black', linewidth=2)

    # dB Scale and major ticks
    db_values = [-20, -10, -7, -5, -3, -1, 0, 1, 2, 3, 4]
    tick_angles_deg = np.linspace(start_angle_deg, end_angle_deg, len(db_values))

    for i, db in enumerate(db_values):
        angle_rad = np.deg2rad(tick_angles_deg[i])
        x_start = center_x + radius * np.cos(angle_rad)
        y_start = center_y + radius * np.sin(angle_rad)

        # Longer ticks for major values
        tick_length = 0.04 if db % 10 == 0 or db == 0 else 0.03
        if db >= 0:
            tick_length = 0.05  # Make positive ticks longer and bolder

        x_end = center_x + (radius - tick_length) * np.cos(angle_rad)
        y_end = center_y + (radius - tick_length) * np.sin(angle_rad)
        ax.plot([x_start, x_end], [y_start, y_end], color='black', linewidth=1.5 if db >= 0 else 1)

        # Add dB labels
        label_radius = radius + 0.05
        label_x = center_x + label_radius * np.cos(angle_rad)
        label_y = center_y + label_radius * np.sin(angle_rad)

        if db == 0:
            ax.text(label_x, label_y, str(db), ha='center', va='center', fontsize=12, fontweight='bold', color='red')
        elif db > 0:
            ax.text(label_x, label_y, str(db), ha='center', va='center', fontsize=12, fontweight='bold', color='red')
        elif db % 10 == 0:
            ax.text(label_x, label_y, str(db), ha='center', va='center', fontsize=10, fontweight='bold')
        else:
            ax.text(label_x, label_y, str(db), ha='center', va='center', fontsize=9)


    # "dB" label in the middle
    ax.text(center_x, center_y + 0.3, 'dB', ha='center', va='center', fontsize=14, fontweight='bold')

    # Add the "100%" indicator
    percent_angle_deg = np.deg2rad(300) # Roughly at 0dB or slightly below
    percent_x = center_x + (radius - 0.1) * np.cos(percent_angle_deg)
    percent_y = center_y + (radius - 0.1) * np.sin(percent_angle_deg)
    ax.text(percent_x, percent_y, '100%', ha='center', va='center', fontsize=10, color='red', rotation=0)

    # Highlight the "red zone" for positive dB values
    red_zone_start_angle = np.deg2rad(tick_angles_deg[db_values.index(0)])
    red_zone_end_angle = end_angle_rad
    red_theta = np.linspace(red_zone_start_angle, red_zone_end_angle, 100)
    red_x_inner = center_x + (radius - 0.02) * np.cos(red_theta)
    red_y_inner = center_y + (radius - 0.02) * np.sin(red_theta)
    red_x_outer = center_x + (radius + 0.02) * np.cos(red_theta)
    red_y_outer = center_y + (radius + 0.02) * np.sin(red_theta)
    ax.fill_between(red_x_inner, red_y_inner, red_y_outer, color='red', alpha=0.3, linewidth=0)


    ax.set_aspect('equal', adjustable='box')
    ax.set_xlim(0, 1)
    ax.set_ylim(-0.5, 0.7)

    plt.tight_layout()
    plt.savefig(filename, transparent=True)
    plt.close(fig)

create_vu_meter_scale()
print("vu_meter_scale.png")
