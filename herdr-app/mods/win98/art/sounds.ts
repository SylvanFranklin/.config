import { spawnSync } from 'node:child_process';
import { mkdirSync } from 'node:fs';
import { resolve } from 'node:path';
const dir=`${resolve(process.argv[2]??'/var/tmp/herdr98')}/mods/win98/sounds`;
mkdirSync(dir,{recursive:true});
const pi='2*PI';
const tone=(f:number,delay=0,decay=2)=>`sin(${pi}*${f}*(t-${delay}))*exp(-${decay}*(t-${delay}))*gte(t,${delay})`;
const chord=(fs:number[],delay=0,decay=2)=>fs.map(f=>tone(f,delay,decay)).join('+');
const jobs:[string,number,string,string][]=[
 ['startup',4,`(${chord([261.63,329.63,392],0,0.7)}+${chord([392,493.88,587.33],0.75,1)}+${chord([523.25,659.25,783.99],1.5,1.1)})/10`,'afade=t=in:d=0.5,afade=t=out:st=2.8:d=1.2,aecho=0.6:0.3:140|270:0.2|0.1'],
 ['shutdown',3.2,`(${chord([523.25,659.25,783.99],0,1.2)}+${chord([392,493.88,587.33],0.5,1.2)}+${chord([261.63,329.63,392],1,1.5)})/11`,'afade=t=in:d=0.15,afade=t=out:st=2:d=1.2,aecho=0.6:0.3:160:0.2'],
 ['ding',0.9,`(${tone(1046.5,0,6)}+0.4*${tone(2093,0,9)})/7`,'afade=t=in:d=0.006,afade=t=out:st=0.65:d=0.25'],
 ['chord',1.1,`(${chord([220,277.18,311.13],0,3)})/12`,'afade=t=in:d=0.015,afade=t=out:st=0.75:d=0.35'],
 ['tada',1.5,`(${chord([392,493.88],0,6)}+${chord([392,493.88],0.16,6)}+${chord([523.25,659.25,783.99],0.4,2.8)})/12`,'afade=t=in:d=0.008,afade=t=out:st=1.15:d=0.35'],
 ['start',0.085,`0.075*sin(${pi}*900*t)*exp(-65*t)`,'afade=t=in:d=0.002,afade=t=out:st=0.05:d=0.035'],
 ['menu',0.12,`0.055*sin(${pi}*(1100*t-4000*t*t))*exp(-80*t)`,'afade=t=in:d=0.002,afade=t=out:st=0.03:d=0.03'],
 ['recycle',0.7,'0.13*(random(0)*2-1)*(0.4+0.6*sin(2*PI*19*t)^2)*exp(-4*t)','highpass=f=600,lowpass=f=4500,afade=t=in:d=0.025,afade=t=out:st=0.45:d=0.25'],
 ['clippy',0.65,`0.12*sin(${pi}*(220*t+55*t*t+18*sin(20*t)))*exp(-5*t)`,'afade=t=in:d=0.01,afade=t=out:st=0.4:d=0.25'],
 ['mines-boom',1.1,`0.3*(random(0)*2-1)*exp(-7*t)+0.08*sin(${pi}*(70*t-20*t*t))*exp(-4*t)`,'lowpass=f=900,afade=t=in:d=0.006,afade=t=out:st=0.7:d=0.4'],
];
for(const [name,dur,expr,filter]of jobs){console.log(`Synthesizing ${name}`);const r=spawnSync('ffmpeg',['-hide_banner','-loglevel','warning','-y','-f','lavfi','-i',`aevalsrc='${expr}':s=44100:d=${dur}`,'-af',`${filter},alimiter=limit=0.8:level=false`,'-t',String(dur),'-ac','1','-codec:a','libmp3lame','-b:a','96k',`${dir}/${name}.mp3`],{stdio:'inherit'});if(r.status)process.exit(r.status??1);}
