

var blob;

var blobs = [];
var zoom = 1;

var o_blobs = [];
var blob_npc = null;


import {Socket} from "phoenix"

let socket_agar = new Socket("/socket_agar", {params: {token: window.userToken}})
socket_agar.connect()

let channel = socket_agar.channel("agar:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

  
channel.on("heartbeat", payload => {
    console.log("got heartbeat channel from server")
    console.log(payload);
    if(blob_npc){
      console.log(payload.greenie);
      blob_npc.pos.x = payload.greenie.x;
      blob_npc.pos.y = payload.greenie.y;
    }
  }
)





var s = function(p) {

  p.mouseReleased = function (){
    console.log("released")
    //channel.push("new_msg", {body: "pressed"})
    channel.push("new_pos",
        {body: {pos_x: blob.pos.x,
                pos_y: blob.pos.y}})
  }

  function Blob3(x, y, r) {
    console.log("building blob")
    this.color = 255;
    this.pos = new p5.Vector(x, y);
    this.r = r;
    this.vel = new p5.Vector(0,0);
  
    this.update = function() {
      
      if(p.mouseIsPressed){
      var newvel = new p5.Vector(p.mouseX-p.width/2, p.mouseY-p.height/2);
      newvel.setMag(3);
      this.vel.lerp(newvel, 0.2);
      this.pos.add(this.vel);
      }
      
    }
  
    this.eats = function(other) {
      var d = p5.Vector.dist(this.pos, other.pos);
      if (d < this.r + other.r) {
        var sum = p.PI * this.r * this.r + p.PI * other.r * other.r;
        this.r = p.sqrt(sum / p.PI);
        //this.r += other.r;
        return true;
      } else {
        return false;
      }
    }
  
    this.show = function() {
      p.fill(this.color, this.color, 255);
      p.ellipse(this.pos.x, this.pos.y, this.r*2, this.r*2);
    }
  }

p.setup = function() {
  var c = p.createCanvas(600, 600);
  c.parent("sketchContainer")
  blob = new Blob3(0, 0, 64);
  blob_npc = new Blob3(30, 0, 48);
  blob_npc.color = 180

  for (var i = 0; i < 200; i++) {
    var x = p.random(-p.width, p.width);
    var y = p.random(-p.height,p.height);
    blobs[i] = new Blob3(x, y, 16);
  }
}

p.draw = function() {
  p.background(100);

  p.translate(p.width/2, p.height/2);
  var newzoom = 64 / blob.r;
  zoom = p.lerp(zoom, newzoom, 0.1);
  p.scale(zoom);
  p.translate(-blob.pos.x, -blob.pos.y);

  for (var i = blobs.length-1; i >=0; i--) {
    blobs[i].show();
    if (blob.eats(blobs[i])) {
      blobs.splice(i, 1);
    }
  }


  blob.show();
  blob.update();

  blob_npc.show();
}
}

var myp5 = new p5(s);

