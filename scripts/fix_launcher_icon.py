#!/usr/bin/env python3
"""
Script to fix launcher icon zoom issue by creating properly sized adaptive icon foreground
"""

import os
import sys
from PIL import Image, ImageDraw

def create_adaptive_icon_foreground(input_path, output_path, padding_percent=20):
    """
    Create adaptive icon foreground with proper padding to prevent zoom/crop issues
    
    Args:
        input_path: Path to original app_icon.png
        output_path: Path to save the new foreground icon
        padding_percent: Percentage of padding to add (default 20%)
    """
    try:
        # Open the original icon
        original = Image.open(input_path)
        
        # Convert to RGBA if not already
        if original.mode != 'RGBA':
            original = original.convert('RGBA')
        
        # Get original size
        orig_width, orig_height = original.size
        
        # Calculate new size with padding
        padding = int(min(orig_width, orig_height) * padding_percent / 100)
        new_size = max(orig_width, orig_height) + (padding * 2)
        
        # Create new image with transparent background
        new_image = Image.new('RGBA', (new_size, new_size), (0, 0, 0, 0))
        
        # Calculate position to center the original icon
        x_offset = (new_size - orig_width) // 2
        y_offset = (new_size - orig_height) // 2
        
        # Paste the original icon onto the new image
        new_image.paste(original, (x_offset, y_offset), original)
        
        # Save the new image
        new_image.save(output_path, 'PNG')
        print(f"✅ Created adaptive icon foreground: {output_path}")
        print(f"   Original size: {orig_width}x{orig_height}")
        print(f"   New size: {new_size}x{new_size}")
        print(f"   Padding: {padding}px ({padding_percent}%)")
        
        return True
        
    except Exception as e:
        print(f"❌ Error creating adaptive icon: {e}")
        return False

def main():
    # Paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    input_icon = os.path.join(project_root, "assets", "app_icon.png")
    output_icon = os.path.join(project_root, "assets", "app_icon_adaptive.png")
    
    # Check if input file exists
    if not os.path.exists(input_icon):
        print(f"❌ Input icon not found: {input_icon}")
        return False
    
    print("🔧 Fixing launcher icon zoom issue...")
    print(f"📁 Input: {input_icon}")
    print(f"📁 Output: {output_icon}")
    
    # Create adaptive icon with 25% padding for better visibility
    success = create_adaptive_icon_foreground(input_icon, output_icon, padding_percent=25)
    
    if success:
        print("\n✅ Icon fix completed!")
        print("\nNext steps:")
        print("1. Update pubspec.yaml to use the new adaptive icon")
        print("2. Run: flutter pub get")
        print("3. Run: flutter pub run flutter_launcher_icons:main")
        print("4. Rebuild the app")
    
    return success

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
