/**
 * Generates Android launcher icons from a source PNG.
 *
 * Standard mipmap sizes (px):
 *   mdpi    48×48   (baseline)
 *   hdpi    72×72
 *   xhdpi   96×96
 *   xxhdpi  144×144
 *   xxxhdpi 192×192
 *
 * Produces both ic_launcher.webp (square, full-bleed) and
 * ic_launcher_round.webp (circular crop) for each density.
 */

const sharp = require('sharp');
const path  = require('path');
const fs    = require('fs');

const SRC  = 'C:\\khwab icon.png';
const ROOT = path.resolve(__dirname, '../../../khwab/app/src/main/res');

const SIZES = [
  { folder: 'mipmap-mdpi',     px: 48  },
  { folder: 'mipmap-hdpi',     px: 72  },
  { folder: 'mipmap-xhdpi',    px: 96  },
  { folder: 'mipmap-xxhdpi',   px: 144 },
  { folder: 'mipmap-xxxhdpi',  px: 192 },
];

async function makeSquare(px) {
  return sharp(SRC)
    .resize(px, px, { fit: 'cover', position: 'centre' })
    .webp({ quality: 95 })
    .toBuffer();
}

async function makeRound(px) {
  // Create a circular SVG mask at the required size.
  const r = px / 2;
  const mask = Buffer.from(
    `<svg width="${px}" height="${px}">` +
    `<circle cx="${r}" cy="${r}" r="${r}" fill="white"/>` +
    `</svg>`
  );

  return sharp(SRC)
    .resize(px, px, { fit: 'cover', position: 'centre' })
    .composite([{ input: mask, blend: 'dest-in' }])
    .webp({ quality: 95 })
    .toBuffer();
}

(async () => {
  for (const { folder, px } of SIZES) {
    const dir = path.join(ROOT, folder);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

    const square = await makeSquare(px);
    fs.writeFileSync(path.join(dir, 'ic_launcher.webp'), square);

    const round = await makeRound(px);
    fs.writeFileSync(path.join(dir, 'ic_launcher_round.webp'), round);

    console.log(`✓ ${folder}  (${px}×${px}px)`);
  }
  console.log('\nAll icons written successfully.');
})();
