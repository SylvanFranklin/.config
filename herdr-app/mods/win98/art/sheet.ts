import { readdirSync,unlinkSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';
const base=resolve(process.argv[2]??'/var/tmp/herdr98'),icons=`${base}/mods/win98/icons`,font=fileURLToPath(new URL('../fonts/PixelatedMSSansSerif-Regular.ttf',import.meta.url));
const files=readdirSync(icons).filter(x=>x.endsWith('.svg')).sort();
const out:string[]=[];
for(let i=0;i<files.length;i++){
 const file=files[i],path=`${base}/art/cell-${i}.png`;
 const xml=Bun.file(`${icons}/${file}`);const txt=await xml.text();const view=txt.match(/viewBox="0 0 (\d+) (\d+)"/)!;const w=Number(view[1]),h=Number(view[2]);
 const args=['-size','228x101','xc:#c0c0c0','-fill','#008080','-draw','rectangle 114,0 227,100'];
 for(const [offset,scale]of [[8,1],[48,2],[122,1],[162,2]])args.push('(','-background','none',`${icons}/${file}`,'-filter','point','-resize',`${w*scale}x${h*scale}!`,')','-geometry',`+${offset}+${9+Math.floor((64-h*scale)/2)}`,'-composite');
 args.push('+antialias','-font',font,'-pointsize','11','-fill','black','-annotate','+4+90',file.replace('.svg',''),path);
 const r=spawnSync('magick',args,{stdio:'inherit'});if(r.status)throw Error(file);out.push(path);
}
const r=spawnSync('magick',['montage',...out,'-tile','5x','-geometry','+2+2','-background','#404040',`${base}/art/sheet.png`],{stdio:'inherit'});if(r.status)throw Error('sheet');
for(const path of out)unlinkSync(path);
console.log(`Contact sheet: ${base}/art/sheet.png (${files.length} icons)`);
