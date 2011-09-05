// TLabel() GMaps API extension copyright 2005-2006 Tom Mangan
// http://gmaps.tommangan.us/tlabel.html
// free for non-commercial use
function TLabel(){}
TLabel.prototype.initialize=function(a){
 this.parentMap=a;
 var b=document.createElement('span');
 b.setAttribute('id',this.id);
 b.innerHTML=this.content;
 document.body.appendChild(b);
 b.style.position='absolute';
 b.style.zIndex=1;
 if(this.percentOpacity){this.setOpacity(this.percentOpacity);}
 this.w = document.getElementById(this.id).offsetWidth;
 this.h = document.getElementById(this.id).offsetHeight;
 this.mapTray=a.getPane(G_MAP_MAP_PANE);
 this.mapTray.appendChild(b);
 if(!this.markerOffset){this.markerOffset=new GSize(0,0);}
 this.setPosition();
 GEvent.bind(a,"zoomend",this,function(){this.setPosition()});
 GEvent.bind(a,"moveend",this,function(){this.setPosition()});
}
TLabel.prototype.setPosition=function(a){
 if(a){this.anchorLatLng=a;}
 var b=this.parentMap.fromLatLngToDivPixel(this.anchorLatLng);
 var x=parseInt(b.x);
 var y=parseInt(b.y);
 with(Math){switch(this.anchorPoint){
  case 'topLeft':break;
  case 'topCenter':x-=floor(this.w/2);break;
  case 'topRight':x-=this.w;break;
  case 'midRight':x-=this.w;y-=floor(this.h/2);break;
  case 'bottomRight':x-=this.w;y-=this.h;break;
  case 'bottomCenter':x-=floor(this.w/2);y-=this.h;break;
  case 'bottomLeft':y-=this.h;break;
  case 'midLeft':y-=floor(this.h/2);break;
  case 'center':x-=floor(this.w/2);y-=floor(this.h/2);break;
  default:break;
 }}
 var d=document.getElementById(this.id);
 d.style.left=x-this.markerOffset.width+'px';
 d.style.top=y-this.markerOffset.height+'px';
}
TLabel.prototype.setOpacity=function(b){
 if(b<0){b=0;} if(b>100){b=100;}
 var c=b/100;
 var d=document.getElementById(this.id);
 if(typeof(d.style.filter)=='string'){d.style.filter='alpha(opacity:'+b+')';}
 if(typeof(d.style.KHTMLOpacity)=='string'){d.style.KHTMLOpacity=c;}
 if(typeof(d.style.MozOpacity)=='string'){d.style.MozOpacity=c;}
 if(typeof(d.style.opacity)=='string'){d.style.opacity=c;}
}
GMap2.prototype.addTLabel=function(a){
 a.initialize(this);
}
GMap2.prototype.removeTLabel=function(a){
 var b=document.getElementById(a.id);
 this.getPane(G_MAP_MAP_PANE).removeChild(b);
 delete(b);
}
