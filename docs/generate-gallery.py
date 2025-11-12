#!/usr/bin/env python3
"""
Generate HTML gallery for 3D models and images
"""
import os
import json
from pathlib import Path
from collections import defaultdict

def scan_assets(assets_dir):
    """Scan assets directory and categorize files"""
    categories = defaultdict(lambda: {'stl': [], 'images': []})

    for root, dirs, files in os.walk(assets_dir):
        for file in files:
            if file.endswith(('.stl', '.STL')):
                rel_path = os.path.relpath(os.path.join(root, file), assets_dir)
                category = rel_path.split(os.sep)[0] if os.sep in rel_path else 'root'
                categories[category]['stl'].append(rel_path)
            elif file.endswith(('.png', '.jpg', '.jpeg', '.PNG', '.JPG', '.JPEG')):
                rel_path = os.path.relpath(os.path.join(root, file), assets_dir)
                category = rel_path.split(os.sep)[0] if os.sep in rel_path else 'root'
                categories[category]['images'].append(rel_path)

    return dict(categories)

def generate_html(categories):
    """Generate HTML gallery page"""
    html = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MerryKombo 3D Design Gallery</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }

        h1 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 2.5em;
            text-align: center;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
            font-size: 1.1em;
        }

        .category {
            margin-bottom: 60px;
        }

        .category-title {
            color: #764ba2;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
            margin-bottom: 25px;
            font-size: 1.8em;
            text-transform: capitalize;
        }

        .section-title {
            color: #555;
            margin: 20px 0 15px 0;
            font-size: 1.3em;
            display: flex;
            align-items: center;
        }

        .section-title::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 20px;
            background: #667eea;
            margin-right: 10px;
        }

        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .item {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            border-color: #667eea;
        }

        .item img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .item-name {
            font-size: 0.9em;
            color: #555;
            word-break: break-word;
            line-height: 1.4;
        }

        .stl-icon {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            color: white;
            font-size: 3em;
        }

        .badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.75em;
            margin-left: 10px;
            font-weight: 500;
        }

        .stats {
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 40px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .stat {
            text-align: center;
        }

        .stat-value {
            font-size: 2.5em;
            color: #667eea;
            font-weight: bold;
        }

        .stat-label {
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .download-btn {
            background: #667eea;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            margin-top: 8px;
            display: inline-block;
            font-size: 0.85em;
            transition: background 0.3s ease;
        }

        .download-btn:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎨 MerryKombo 3D Design Gallery</h1>
        <p class="subtitle">A collection of 3D models and designs for various projects</p>

        <div class="stats">
'''

    # Calculate stats
    total_stl = sum(len(cat['stl']) for cat in categories.values())
    total_images = sum(len(cat['images']) for cat in categories.values())
    total_categories = len(categories)

    html += f'''
            <div class="stat">
                <div class="stat-value">{total_stl}</div>
                <div class="stat-label">STL Models</div>
            </div>
            <div class="stat">
                <div class="stat-value">{total_images}</div>
                <div class="stat-label">Images</div>
            </div>
            <div class="stat">
                <div class="stat-value">{total_categories}</div>
                <div class="stat-label">Categories</div>
            </div>
        </div>
'''

    # Generate categories
    for category, files in sorted(categories.items()):
        if not files['stl'] and not files['images']:
            continue

        html += f'''
        <div class="category">
            <h2 class="category-title">{category.replace('_', ' ')}</h2>
'''

        # STL files
        if files['stl']:
            html += f'''
            <h3 class="section-title">3D Models <span class="badge">{len(files['stl'])} files</span></h3>
            <div class="gallery">
'''
            for stl in sorted(files['stl']):
                filename = os.path.basename(stl)
                html += f'''
                <div class="item">
                    <div class="stl-icon">📦</div>
                    <div class="item-name">{filename}</div>
                    <a href="../assets/{stl}" class="download-btn" download>Download STL</a>
                </div>
'''
            html += '''
            </div>
'''

        # Images
        if files['images']:
            html += f'''
            <h3 class="section-title">Images <span class="badge">{len(files['images'])} files</span></h3>
            <div class="gallery">
'''
            for img in sorted(files['images']):
                filename = os.path.basename(img)
                html += f'''
                <div class="item">
                    <img src="../assets/{img}" alt="{filename}" loading="lazy">
                    <div class="item-name">{filename}</div>
                    <a href="../assets/{img}" class="download-btn" download>Download Image</a>
                </div>
'''
            html += '''
            </div>
'''

        html += '''
        </div>
'''

    html += '''
    </div>
</body>
</html>
'''
    return html

def main():
    # Get paths
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    assets_dir = project_dir / 'assets'

    print(f"Scanning assets in: {assets_dir}")

    # Scan assets
    categories = scan_assets(str(assets_dir))

    # Generate HTML
    html = generate_html(categories)

    # Write HTML file
    output_path = script_dir / 'index.html'
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"Gallery generated: {output_path}")
    print(f"Total categories: {len(categories)}")
    print(f"Total STL files: {sum(len(cat['stl']) for cat in categories.values())}")
    print(f"Total images: {sum(len(cat['images']) for cat in categories.values())}")

if __name__ == '__main__':
    main()
