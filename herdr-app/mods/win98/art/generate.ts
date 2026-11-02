import { mkdirSync, writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';
const root=resolve(process.argv[2]??'/var/tmp/herdr98'),base=`${root}/mods/win98`,art=`${root}/art`;
mkdirSync(art,{recursive:true});
for(const d of ['icons','img','sounds']) mkdirSync(`${base}/${d}`,{recursive:true});
const P: Record<string,string>={K:'#000000',W:'#ffffff',s:'#808080',l:'#dfdfdf',c:'#c0c0c0',n:'#000080',b:'#0000ff',a:'#008080',t:'#00ffff',g:'#008000',G:'#00ff00',r:'#800000',R:'#ff0000',y:'#808000',Y:'#ffff00',p:'#800080',f:'#ffffc0',e:'#c8c0a0',d:'#808060'};
class Pix {
 w:number; h:number; a:string[][];
 constructor(w:number,h=w){this.w=w;this.h=h;this.a=Array.from({length:h},()=>Array(w).fill(''));}
 dot(x:number,y:number,c:string){x=Math.round(x);y=Math.round(y);if(x>=0&&y>=0&&x<this.w&&y<this.h)this.a[y][x]=c;}
 rect(x:number,y:number,w:number,h:number,c:string){for(let j=Math.round(y);j<Math.round(y+h);j++)for(let i=Math.round(x);i<Math.round(x+w);i++)this.dot(i,j,c);}
 line(x:number,y:number,x2:number,y2:number,c:string,t=1){const n=Math.max(Math.abs(x2-x),Math.abs(y2-y));for(let i=0;i<=n;i++)this.rect(Math.round(x+(x2-x)*i/(n||1)),Math.round(y+(y2-y)*i/(n||1)),t,t,c);}
 poly(pts:number[][],c:string){for(let y=0;y<this.h;y++)for(let x=0;x<this.w;x++){let hit=false;for(let i=0,j=pts.length-1;i<pts.length;j=i++){const [xi,yi]=pts[i],[xj,yj]=pts[j];if((yi>y)!=(yj>y)&&x<(xj-xi)*(y-yi)/(yj-yi)+xi)hit=!hit;}if(hit)this.dot(x,y,c);}}
 ellipse(x:number,y:number,rx:number,ry:number,c:string){for(let j=-ry;j<=ry;j++)for(let i=-rx;i<=rx;i++)if(i*i/(rx*rx)+j*j/(ry*ry)<=1)this.dot(x+i,y+j,c);}
 ascii(rows:string[],x=0,y=0){rows.forEach((row,j)=>[...row].forEach((c,i)=>{if(c!=='.'&&c!==' ')this.dot(x+i,y+j,c);}));}
 svg(tint=false){let r='';for(let y=0;y<this.h;y++){for(let x=0;x<this.w;){const c=this.a[y][x];let z=x+1;while(z<this.w&&this.a[y][z]===c)z++;if(c)r+=`<rect x="${x}" y="${y}" width="${z-x}" height="1" fill="${tint?'currentColor':P[c]||c.slice(0,7)}"${c.startsWith('#')&&c.length===9?` fill-opacity="${parseInt(c.slice(7),16)/255}"`:''}/>`;x=z;}}return `<svg xmlns="http://www.w3.org/2000/svg" width="${this.w}" height="${this.h}" viewBox="0 0 ${this.w} ${this.h}" shape-rendering="crispEdges">${r}</svg>`;}
}
const glyph:Record<string,string[]>={
 '?':['.KKK.','K...K','....K','...K.','..K..','.....','..K..'],
 '!':['K','K','K','K','K','.','K'],
 'i':['K','.','K','K','K','K','K'],
 'C':['.KKK','K...','K...','K...','.KKK'],
 ':':['.','K','.','K','.'],
 '>':['K..','.K.','..K','.K.','K..'],
 '_':['....','....','....','....','KKKK'],
 'H':['K...K','K...K','K...K','KKKKK','K...K','K...K','K...K'],
 'e':['.....','.....','.KKK.','K...K','KKKKK','K....','.KKKK'],
 'r':['....','....','K.KK','KK..','K...','K...','K...'],
 'd':['....K','....K','.KK.K','K..KK','K...K','K..KK','.KK.K'],
 '9':['.KKK.','K...K','K...K','.KKKK','....K','...K.','.KK..'],
 '8':['.KKK.','K...K','K...K','.KKK.','K...K','K...K','.KKK.']};
function text(p:Pix,s:string,x:number,y:number,c='K',scale=1){for(const ch of s){const rows=glyph[ch];if(!rows){x+=3*scale;continue;}rows.forEach((r,j)=>[...r].forEach((a,i)=>{if(a==='K')p.rect(x+i*scale,y+j*scale,scale,scale,c);}));x+=(rows[0].length+1)*scale;}}
const ram16=['............KK..','..........KKKKK.','....KKKK.KK...KK','...KKKKKKK.KK..K','..KKKKKKKKK..K.K','.KKWKKKKKK.KKK.K','KKKKKKKKKKK...KK','KKKKKKKKK.KKKKK.','.KKKKKKKKKKKKKK.','.....KKKKKKKKKK.','......KKKKKKKKK.','......KKKKKKKKK.'];
const ram32=['....................KKKKK.......','.................KKKKKKKKKK.....','...............KKKK......KKK....','..............KKK...KKKK...KK...','......KKKKKK.KKK..KKKKKKK..KK...','.....KKKKKKKKKKK.KK....KKK..KK..','....KKKKKKKKKKKK.K..KK..KK..KK..','...KKKKKKKKKKKKKK.KKKK..KK..KK..','..KKKKKWKKKKKKKKKKK....KKK..KK..','.KKKKKKKKKKKKKKKKK.KKKKKK..KK...','KKKKKKKKKKKKKKKKKKK.......KKK...','KKKKKKKKKKKKKKKKKKKKKKKKKKKK....','KKKKKKKKKKKKKKKKK.KKKKKKKKK.....','.KKKKKKKKKKKKKKKKKKKKKKKKKKK....','..KKKKKKKKKKKKKKKKKKKKKKKKKK....','.........KKKKKKKKKKKKKKKKKKK....','..........KKKKKKKKKKKKKKKKKK....','...........KKKKKKKKKKKKKKKKK....','...........KKKKKKKKKKKKKKKKK....','...........KKKKKKKKKKKKKKKKK....'];
function logo(p:Pix){if(p.w===16){p.rect(0,3,2,2,'R');p.rect(3,1,2,2,'G');p.rect(1,10,2,2,'b');p.rect(4,13,2,2,'Y');p.ascii(['.......KKKK.','..KKK.KK..KK','.KKKKKK.KK.K','KKWKKKKK.K.K','KKKKKKK.KK.K','.KKKKKKK..KK','....KKKKKKK.','.....KKKKKK.','.....KKKKKK.','.....KKKKKK.'],4,4);}else{for(const [x,y,c] of [[0,7,'R'],[4,4,'R'],[7,1,'G'],[1,15,'b'],[5,18,'Y'],[0,23,'b'],[5,25,'Y']] as const)p.rect(x,y,3,3,c);p.ascii(['................KKKKK.....','..............KKK...KKK...','.............KK..KKK..KK..','......KKKKK.KK.KK...K..K..','.....KKKKKKKKK.K..K..K.K..','....KKKKKKKKKKK.KKK..K.K..','...KKKWKKKKKKKKK...KK..K..','..KKKKKKKKKKKKK.KKKK..KK..','.KKKKKKKKKKKKKKK.....KK...','KKKKKKKKKKKKKKKKKKKKKK....','KKKKKKKKKKKKKKKKKKKKKK....','.KKKKKKKKKKKKKKKKKKKKK....','........KKKKKKKKKKKKKK....','.........KKKKKKKKKKKKK....','.........KKKKKKKKKKKKK....','.........KKKKKKKKKKKKK....','.........KKKKKKKKKKKKK....'],6,8);text(p,'>',11,17,'W');p.rect(16,21,3,1,'W');}}
function icon(name:string,n:number){const p=new Pix(n),z=n===32?2:1;
 // Both sizes are rasterized on their own pixel grid, with size-specific margins and detail.
 const r=(x:number,y:number,w:number,h:number,c:string)=>p.rect(x*z,y*z,w*z,h*z,c);
 const ln=(x:number,y:number,a:number,b:number,c:string,t=1)=>p.line(Math.round(x*z),Math.round(y*z),Math.round(a*z),Math.round(b*z),c,t);
 const ell=(x:number,y:number,rx:number,ry:number,c:string)=>p.ellipse(Math.round(x*z),Math.round(y*z),Math.round(rx*z),Math.round(ry*z),c);
 const poly=(a:number[][],c:string)=>p.poly(a.map(([x,y])=>[x*z,y*z]),c);
 const box=(x:number,y:number,w:number,h:number,fill='c')=>{const xx=x*z,yy=y*z,ww=w*z,hh=h*z;p.rect(xx,yy,ww,hh,'K');p.rect(xx,yy,ww-1,hh-1,'W');p.rect(xx+1,yy+1,ww-2,hh-2,fill);p.line(xx+1,yy+hh-2,xx+ww-2,yy+hh-2,'s');p.line(xx+ww-2,yy+1,xx+ww-2,yy+hh-2,'s');};
 const doc=()=>{poly([[4,1],[10,1],[13,4],[13,15],[3,15],[3,1]],'K');poly([[4,2],[9,2],[9,5],[12,5],[12,14],[4,14]],'W');r(10,2,1,2,'c');for(let y=7;y<13;y+=2)r(5,y,5,0.5,'n');};
 const folder=(open=false)=>{poly([[1,4],[1,2],[6,2],[8,4],[14,4],[15,5],[15,14],[1,14]],'K');r(2,3,4,2,'Y');r(2,5,12,8,'y');r(2,5,11,1,'Y');if(open){poly([[3,7],[15,7],[13,13],[1,13]],'K');poly([[4,8],[14,8],[12,12],[2,12]],'Y');}else{r(2,6,11,6,'Y');ln(2,12,13,12,'y');}};
 const monitor=(colors=false)=>{box(2,1,12,10,'e');r(3,2,10,7,'K');r(4,3,8,5,'a');if(colors){r(4,3,4,2,'R');r(8,3,4,2,'G');r(4,5,4,3,'b');r(8,5,4,3,'Y');}else{ln(4,7,10,3,'t');}r(7,11,3,2,'s');box(4,13,9,2,'e');};
 const globe=()=>{ell(8,7,6,6,'K');ell(7.5,6.5,5.5,5.5,'b');ell(7,6,4,5,'t');poly([[5,3],[8,3],[9,5],[7,6],[7,8],[4,7]],'g');poly([[9,8],[12,6],[12,9],[10,11],[8,10]],'g');ln(3,6,12,6,'n');ln(7,2,7,11,'n');};
 const speaker=()=>{r(1,6,4,5,'K');r(2,7,3,3,'c');poly([[4,6],[9,2],[10,2],[10,14],[9,14],[4,10]],'K');poly([[5,6],[9,3],[9,12],[5,10]],'s');ln(5,6,8,4,'W');ln(12,5,13,6,'K');ln(13,6,13,9,'K');ln(12,10,13,9,'K');};
 switch(name){
 case 'start':logo(p);break;
 case 'folder':folder();break;case 'folder-open':folder(true);break;
 case 'netfolder':folder();ln(0,15,15,15,'K');r(7,13,2,2,'c');r(2,14,3,1,'W');break;
 case 'computer':monitor();box(1,12,14,3,'e');r(3,13,4,0.5,'K');r(12,13,1,1,'g');break;
 case 'display':monitor(true);break;
 case 'shutdown':monitor();ell(12,4,3,3,'Y');ell(13,3,2,2,'n');break;
 case 'network':globe();box(0,7,7,6);r(1,8,5,3,'n');r(2,13,3,1,'s');box(9,9,6,5);r(10,10,4,2,'a');ln(4,15,12,15,'K');break;
 case 'update':globe();{const q=new Pix(16);logo(q);for(let y=0;y<16;y++)for(let x=0;x<16;x++)if(q.a[y][x])p.dot(Math.round(x*z*.65+5*z),Math.round(y*z*.65+4*z),q.a[y][x]);}break;
 case 'bin':ell(8,4,5,2,'K');poly([[3,4],[13,4],[11,14],[5,14]],'s');poly([[4,5],[12,5],[10,13],[6,13]],'l');for(let y=6;y<13;y+=2)for(let x=5;x<12;x+=2)r(x,y,0.5,1,'s');ell(8,3,5,2,'W');ell(8,3,4,1,'s');break;
 case 'dos':box(0,2,16,12);r(1,3,14,1,'n');r(2,5,12,7,'K');text(p,'C:>',3*z,6*z,'W',1);break;
 case 'mines':ln(1,1,14,14,'K');ln(1,14,14,1,'K');ln(0,8,15,8,'K');ln(8,0,8,15,'K');ell(8,8,5,5,'K');r(5,5,2,2,'W');r(10,10,1,1,'s');break;
 case 'sol':poly([[2,3],[10,0],[14,12],[6,15]],'K');poly([[3,4],[9,1],[13,11],[7,14]],'W');box(6,2,9,13,'W');r(7,3,1,2,'R');poly([[10,6],[12,8],[10,11],[8,8]],'R');break;
 case 'clippy':for(const [a,b,c,d] of [[5,12,3,4],[3,4,5,2],[5,2,9,2],[9,2,11,4],[11,4,10,12],[10,12,7,14],[7,14,5,12],[6,10,6,5],[6,5,8,4],[8,4,9,5],[9,5,8,10]]){ln(a,b,c,d,'K',z+1);ln(a,b,c,d,'l',1);}ell(6,5,2,2,'W');ell(10,5,2,2,'W');r(5,4,1,1,'K');r(9,4,1,1,'K');break;
 case 'programs':folder();box(6,6,9,7,'W');r(7,7,7,1,'n');r(8,10,2,2,'t');break;
 case 'documents':folder();box(6,5,7,8,'W');ln(7,7,11,7,'n');ln(7,9,11,9,'n');break;
 case 'settings':case 'control':box(1,3,14,11,'W');r(2,4,12,2,'n');for(const [x,y,c]of [[3,8,'t'],[7,8,'Y'],[11,8,'R']] as const){box(x,y,2,3,c);}break;
 case 'find':doc();ell(7,7,4,4,'K');ell(7,7,3,3,'a');ell(6,6,2,2,'t');ln(10,10,14,14,'K',2*z);ln(10,11,13,14,'y');break;
 case 'help':poly([[2,2],[6,1],[14,2],[14,14],[5,15],[2,13]],'K');poly([[3,3],[5,2],[5,13],[3,12]],'s');r(6,2,7,11,'n');text(p,'?',7*z,4*z,'W',z);break;
 case 'run':box(4,2,11,8,'W');r(5,3,9,1,'n');poly([[0,8],[5,5],[5,7],[10,7],[10,10],[5,10],[5,12]],'K');poly([[1,8],[4,6],[4,8],[9,8],[9,9],[4,9],[4,11]],'Y');break;
 case 'logoff':box(7,1,7,14,'r');poly([[9,2],[13,3],[13,13],[9,14]],'y');ell(4,7,3,3,'K');ell(4,7,2,2,'Y');ell(4,7,1,1,'K');r(6,7,7,2,'Y');r(10,9,1,2,'Y');r(12,9,1,2,'Y');break;
 case 'taskbar':box(0,2,16,12,'a');r(1,11,14,2,'c');box(1,11,4,2,'c');r(2,11,1,1,'G');box(6,11,6,2,'c');r(1,3,14,1,'n');break;
 case 'drive':case 'netdrive':poly([[3,3],[13,3],[15,8],[15,12],[1,12],[1,8]],'K');poly([[4,4],[12,4],[14,8],[2,8]],'l');r(2,9,12,2,'c');r(3,10,5,0.5,'K');r(12,10,1,1,'g');if(name==='netdrive'){ln(1,15,14,15,'K');r(7,12,2,3,'s');r(2,14,2,1,'W');}break;
 case 'printer':box(4,0,8,8,'W');ln(5,2,10,2,'n');ln(5,4,10,4,'n');box(1,6,14,7,'c');r(2,7,12,2,'l');r(12,8,1,1,'g');r(4,11,8,4,'K');r(5,11,6,4,'W');ln(6,13,9,13,'s');break;
 case 'warning':case 'warn-badge':poly([[8,0],[16,15],[0,15]],'K');poly([[8,2],[14,14],[2,14]],'Y');r(7,5,2,5,'K');r(7,12,2,1,'K');break;
 case 'error':ell(8,8,7,7,'K');ell(7.5,7.5,6.5,6.5,'R');ln(5,5,10,10,'W',z+1);ln(5,10,10,5,'W',z+1);break;
 case 'question':case 'info':ell(8,6,7,6,'K');ell(7.5,5.5,6,5,'W');poly([[5,10],[5,15],[10,10]],'K');poly([[6,10],[6,13],[9,10]],'W');text(p,name==='question'?'?':'i',(name==='question'?5:7)*z,2*z,'n',z);break;
 case 'rename':doc();poly([[5,12],[12,3],[15,5],[8,14],[4,15]],'K');poly([[6,12],[12,4],[14,5],[7,13]],'Y');r(12,3,2,2,'R');r(5,13,2,1,'e');break;
 case 'clock':ell(8,8,7,7,'K');ell(7.5,7.5,6,6,'W');for(const [x,y]of [[8,2],[8,13],[2,8],[13,8]])r(x,y,1,1,'K');ln(8,8,8,4,'K');ln(8,8,11,9,'K');r(7,7,2,2,'K');break;
 case 'taskman':box(0,2,16,12,'W');r(1,3,14,2,'n');for(let y=7;y<13;y+=2){r(2,y,2,1,'a');r(5,y,8,1,'K');}break;
 case 'speaker':case 'speaker-mute':speaker();if(name==='speaker-mute'){ell(10,10,5,5,'R');ell(10,10,3,3,'c');ln(7,13,13,7,'R',z+1);}break;
 case 'hourglass':r(3,0,10,2,'K');r(3,14,10,2,'K');poly([[4,2],[12,2],[11,6],[9,8],[11,10],[12,14],[4,14],[5,10],[7,8],[5,6]],'K');poly([[5,2],[11,2],[10,6],[8,8],[6,6]],'W');poly([[8,8],[10,11],[11,13],[5,13],[6,11]],'Y');ln(6,4,10,4,'Y');break;
 case 'check-badge':ell(8,8,7,7,'W');ln(3,8,6,11,'g',2*z);ln(6,11,12,4,'g',2*z);break;
 default:throw Error(name);
 }
 if(n===32 && ['folder','folder-open','netfolder'].includes(name)){
  // The large folder has its own stepped silhouette and fine bevel.
  p.a=Array.from({length:32},()=>Array(32).fill(''));
  p.poly([[2,8],[2,4],[12,4],[16,8],[28,8],[30,10],[30,27],[2,27]],'K');
  p.poly([[3,8],[3,5],[11,5],[15,9],[28,9],[29,10],[29,26],[3,26]],'y');
  p.rect(4,6,7,3,'Y');p.line(4,5,11,5,'W');p.rect(3,10,25,15,'Y');p.line(3,10,27,10,'W');p.line(3,10,3,24,'W');p.line(4,25,28,25,'y');
  if(name==='folder-open'){p.poly([[7,14],[31,14],[27,27],[2,27]],'K');p.poly([[8,15],[30,15],[26,26],[3,26]],'Y');p.line(8,15,29,15,'W');p.line(4,25,26,25,'y');}
  if(name==='netfolder'){p.line(0,30,31,30,'K');p.rect(15,27,3,3,'s');p.line(1,29,30,29,'l');}
 }
 // Extra single-pixel highlights at 32px, not a nearest-neighbor upscale.
 if(n===32 && !['start','error','question','info','hourglass','check-badge','warn-badge','warning'].includes(name)){
 for(let y=1;y<n-1;y++)for(let x=1;x<n-1;x++){if(p.a[y][x]==='c'&&p.a[y-1][x]==='W'&&(x+y)%3===0)p.a[y][x]='l';}
 }
 if(n===32){const art=p.a.map(row=>[...row]);for(let y=0;y<30;y++)for(let x=0;x<31;x++)if(art[y][x]&&!p.a[y+2][x+1])p.a[y+2][x+1]=(x+y)%2?'#80808066':'#00000033';}
 return p;
}
const names=['start','dos','folder','folder-open','netfolder','computer','bin','network','mines','sol','clippy','programs','documents','settings','find','help','run','logoff','shutdown','update','control','display','taskbar','drive','netdrive','printer','warning','question','info','error','rename','clock','taskman','speaker','speaker-mute'];
for(const name of names)for(const n of [16,32])writeFileSync(`${base}/icons/${name}${n===16?'-sm':''}.svg`,icon(name,n).svg());
for(const name of ['hourglass','check-badge','warn-badge']){writeFileSync(`${base}/icons/${name}-sm.svg`,icon(name,16).svg());const p=new Pix(9);p.ascii(({hourglass:['.KKKKKKK.','..KWWWK..','..KYYYK..','...KWK...','....K....','...KYK...','..KYYYK..','..KYYYK..','.KKKKKKK.'],'check-badge':['.........','.......g.','......gg.','.g...gg..','.gg.gg...','..ggg....','...g.....','.........','.........'],'warn-badge':['....K....','...KYK...','...KYK...','..KYYYK..','..KYKYK..','.KYYKYYK.','.KYYYYYK.','KYYYKYYYK','KKKKKKKKK']} as any)[name]);writeFileSync(`${base}/icons/${name}-xs.svg`,p.svg());}
const controls:Record<string,string[]>={
 'ctl-min':['........','........','........','........','........','KKKKKK..','KKKKKK..'],
 'ctl-max':['KKKKKKKK','KKKKKKKK','K......K','K......K','K......K','K......K','KKKKKKKK'],
 'ctl-restore':['..KKKKKK','..KKKKKK','..K....K','KKKKKK.K','KKKKKKKK','K....K..','KKKKKK..'],
 'ctl-close':['KK....KK','.KK..KK.','..KKKK..','...KK...','..KKKK..','.KK..KK.','KK....KK'],
 'ctl-help':['..KKK...','.K...K..','.....K..','...KK...','...K....','........','...K....'],
 'arrow-right':['K...','KK..','KKK.','KKKK','KKK.','KK..','K...'],
 'arrow-down':['KKKKKKK','.KKKKK.','..KKK..','...K...'],
 'check':['.......','.....KK','....KK.','K..KK..','KKKK...','.KK....','.......']};
for(const [name,rows]of Object.entries(controls)){const p=new Pix(rows[0].length,rows.length);p.ascii(rows);writeFileSync(`${base}/icons/${name}.svg`,p.svg(true));}
function cmd(args:string[]){const s=spawnSync('magick',args,{stdio:'inherit'});if(s.status)throw Error('magick failed');}
const regular=fileURLToPath(new URL('../fonts/PixelatedMSSansSerif-Regular.ttf',import.meta.url)),bold=fileURLToPath(new URL('../fonts/PixelatedMSSansSerif-Bold.ttf',import.meta.url));
// Pixel lettering is rendered before rotation so the banner remains sharp.
cmd(['-size','110x21','xc:none','+antialias','-font',bold,'-pointsize','16','-fill','white','-annotate','+2+17','Herdr','-font',regular,'-fill','#dfdfdf','-annotate','+53+17','98','-rotate','-90',`${base}/img/banner.png`]);
cmd([`${base}/img/banner.png`,'-filter','point','-resize','200%',`${base}/img/banner@2x.png`]);
const largeLogo=new Pix(48,32);for(let j=0;j<ram32.length;j++)for(let i=0;i<ram32[j].length;i++)if(ram32[j][i]==='K')largeLogo.dot(i+17,j+5,'K');largeLogo.dot(23,12,'W');text(largeLogo,'>',23,15,'W');largeLogo.rect(28,19,4,1,'W');for(const[x,y,c]of [[0,9,'R'],[6,6,'R'],[12,3,'G'],[3,17,'b'],[9,14,'b'],[14,11,'G'],[0,25,'b'],[7,23,'Y'],[13,21,'Y']]as const)largeLogo.rect(x,y,4,4,c);writeFileSync(`${art}/logo.svg`,largeLogo.svg());
cmd(['-size','356x80','gradient:white-#a4d2ee','(','-background','none',`${art}/logo.svg`,'-filter','point','-resize','96x64',')','-geometry','+12+8','-composite','+antialias','-font',bold,'-pointsize','32','-fill','black','-annotate','+117+51','Herdr','-font',regular,'-pointsize','32','-annotate','+258+51','98',`${base}/img/about.png`]);
// Seeded low-frequency fractal noise supplies a soft cloud bank, with no downloaded artwork.
cmd(['-seed','98','-size','640x400','plasma:fractal','-colorspace','gray','-blur','0x6','-auto-level','-level','8%,80%','-colorspace','sRGB','+level-colors','#4b94d3,#ffffff','-resize','1280x800',`${base}/img/clouds.png`]);
cmd([`${base}/img/clouds.png`,'-resize','640x480!','(','-background','none',`${art}/logo.svg`,'-filter','point','-resize','240x160',')','-geometry','+67+114','-compose','over','-composite','+antialias','-font',bold,'-pointsize','48','-fill','black','-annotate','+325+200','Herdr','-font',regular,'-pointsize','72','-annotate','+350+275','98',`${base}/img/splash.png`]);
const mon=new Pix(184,170);mon.poly([[6,5],[177,5],[182,11],[182,137],[173,144],[11,144],[2,135],[2,13]],'K');mon.rect(4,8,175,130,'e');mon.line(5,8,176,8,'W');mon.line(4,8,4,134,'W');mon.line(179,12,179,136,'s',2);mon.rect(13,12,160,121,'s');mon.rect(15,14,156,117,'K');mon.rect(17,16,153,113,'');mon.rect(60,144,64,15,'s');mon.poly([[48,156],[132,156],[147,166],[144,169],[38,169],[36,166]],'K');mon.poly([[49,157],[131,157],[141,165],[41,165]],'e');mon.line(43,166,139,166,'s');mon.rect(152,136,12,3,'s');mon.rect(168,136,3,3,'G');writeFileSync(`${art}/monitor.svg`,mon.svg());cmd(['-background','none',`${art}/monitor.svg`,`${base}/img/monitor.png`]);
writeFileSync(`${base}/img/clippy.svg`,`<svg xmlns="http://www.w3.org/2000/svg" width="64" height="80" viewBox="0 0 64 80"><path d="M5 51L52 48 59 74 12 78Z" fill="#ffffa0" stroke="#808000"/><path d="M13 59L49 56M15 64L51 61M17 69L53 66" stroke="#b8b889"/><path d="M24 57C15 58 11 49 13 36L17 17C19 4 40 3 44 14C47 23 40 49 38 56C35 66 23 65 22 55L27 25C28 18 36 18 36 25L31 48" fill="none" stroke="#4c4c4c" stroke-width="6" stroke-linecap="round"/><path d="M24 57C15 58 11 49 13 36L17 17C19 4 40 3 44 14C47 23 40 49 38 56C35 66 23 65 22 55L27 25C28 18 36 18 36 25L31 48" fill="none" stroke="#d0d0d0" stroke-width="3" stroke-linecap="round"/><path d="M24 57C16 56 14 49 15 39L19 18M24 11C33 5 42 10 43 17M24 55L29 25" fill="none" stroke="white" stroke-width="1"/><ellipse cx="25" cy="23" rx="9" ry="11" fill="white" stroke="#444"/><ellipse cx="42" cy="24" rx="9" ry="11" fill="white" stroke="#444"/><ellipse cx="22" cy="20" rx="3" ry="4"/><ellipse cx="39" cy="21" rx="3" ry="4"/><path d="M17 10Q24 5 30 9M36 10Q43 7 49 13" fill="none" stroke="#222" stroke-width="2.5" stroke-linecap="round"/></svg>`);
console.log('Generated icons and images.');
