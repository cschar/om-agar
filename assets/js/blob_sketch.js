

if(window.location.pathname !== '/blob'){
  throw new Error("bad path")
}
var blob;

var blobs = [];
window.blobs = blobs;
var zoom = 1;

var o_blobs = [];
var blob_npc = null;
var foods = null;
var init_spawned_foods = false;


var player_id = null;
window.player_id = player_id;

var gamedata = null;
window.gd = gamedata;

var other_last_pos = null;
var other_vel = {};

import {Socket} from "phoenix"

let socket_agar = new Socket("/socket_agar", {params: {token: window.userToken}})
socket_agar.connect()

let channel = socket_agar.channel("agar:lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
    window.player_id = player_id = resp.player_id;

  })
  .receive("error", resp => { console.log("Unable to join", resp) })

  
channel.on("heartbeat", payload => {
    // console.log("got heartbeat channel from server")
    // console.log(payload);
    gamedata = payload;
    other_vel = {}
    window.gd = payload;

    window.foods = foods = payload.foods;

    if(blob_npc){
      blob_npc.pos.x = payload.greenie.x;
      blob_npc.pos.y = payload.greenie.y;
      blob_npc.r = payload.greenie.r;
    }
  }
)


var blobs_eaten = []

var s = function(p) {

  p.mouseReleased = function (){
    console.log("released")
    //channel.push("new_msg", {body: "pressed"})
    channel.push("new_pos",
        {body: {pos_x: blob.pos.x,
                pos_y: blob.pos.y,
                radius: blob.r}})
  }

  function Blob3(x, y, r, id=null) {
    
    this.id = id;
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

        drawArrow(this.pos, newvel, 'red');
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

  //for (var i = 0; i < 200; i++) {
  //  var x = p.random(-p.width, p.width);
  //  var y = p.random(-p.height,p.height);
  //  blobs[i] = new Blob3(x, y, 16);
  //}
}

p.draw = function() {
  p.background(120);
  p.textSize(20);
  p.translate(p.width/2, p.height/2);
  var newzoom = 64 / blob.r;
  zoom = p.lerp(zoom, newzoom, 0.1);
  p.scale(zoom);
  p.translate(-blob.pos.x, -blob.pos.y);

  let keys = null;
  if(gamedata) {
    keys = Object.keys(gamedata);
  }



  if(init_spawned_foods && keys){

    //update food blobs

    //draw food blobs
    for (var i = blobs.length-1; i >=0; i--) {
      blobs[i].show();
      if (blob.eats(blobs[i])) {
        blobs_eaten.push(blobs[i].id)
        blobs.splice(i, 1);

      }
    }
  }else if(keys){
      console.log("making food data")
      let food_spots = gamedata.food_master.spots;

      food_spots.map( (spot) => {
          blobs.push(new Blob3(spot.x, spot.y, 16, spot.food_id));
        })
      init_spawned_foods = true;

  }

  p.fill(160,255,160)
  p.text(`blob[${player_id}]: ${blob.r}`, blob.pos.x+blob.r, blob.pos.y)

    if(p.frameCount % 60 == 0){
    //send position and food eaten info every 1 sec
    channel.push("food_update",
        {body: {eaten: blobs_eaten}})
    blobs_eaten = []


    channel.push("new_pos",
        {body: {pos_x: blob.pos.x,
                pos_y: blob.pos.y,
                radius: blob.r}})


      //Resync foods to global state every 2 sec
      if(p.frameCount % 120 == 0 && gamedata) {
        //remove foods that have been eaten by otehr players
        let food_spots = gamedata.food_master.spots;
        //let food_spot_keys = Object.keys(food_spots)


        
        blobs = []
        food_spots.map( (spot) => {
          blobs.push(new Blob3(spot.x, spot.y, 16, spot.food_id));
        })

      }


  }





  blob.show();
  blob.update();

  blob_npc.show();

  //other players
  if(keys){

    keys = keys.filter( (x) => (x !== "greenie"
                             && x !== "food_master"
                             && x !== player_id))
    // keys = keys.filter( (x) => (x !== "food_master"))
    // keys = keys.filter( (x) => (x !== player_id))
    //
    
    for( let player_id of keys){
       p.fill(130, 130, 255);
      let pos = gamedata[player_id]
      //let r = 30

      if(other_last_pos){ //initialized
        
        let last_pos = other_last_pos[player_id];
        if (last_pos){ //if player didnt leave
          
          //new location , set velocity
          if (last_pos.x !== pos.x){ 
            
            var v1 = p.createVector(pos.x - last_pos.x, pos.y - last_pos.y);
            // v1.setMag(10);
            v1.mult(3);
            other_vel[player_id] = {destination: v1,
                                    ticks: 0,
                                    current: p.createVector(pos.x, pos.y)};

            
            
            
            p.fill('blue')
            p.ellipse(pos.x, pos.y, pos.r*2, pos.r*2);
            p.text(`blobza[${player_id}]:  = ${pos.r}`, pos.x + pos.r, pos.y)
            
            //same location
            //how do we know if its stale, or a new payload with same info
          }else if(last_pos.x == pos.x){ 
            
            //stale, interpolate
            if(other_vel[player_id]){
              var dest = other_vel[player_id].destination.copy()
              dest.mult(0.001 * other_vel[player_id].ticks);
              other_vel[player_id].ticks += 1;
  
              // p.fill('red')
              p.fill(160,255,230)
              var new_pos = p.createVector(pos.x + dest.x, pos.y + dest.y);
              p.ellipse(new_pos.x, new_pos.y, pos.r*2, pos.r*2);
              p.text(`blob[${player_id}]:  = ${pos.r}`, new_pos.x + pos.r, new_pos.y)
              drawArrow(pos, dest, 'blue',15)
              // drawArrow(pos, other_vel[player_id].destination, 'green')
                        
            }else{
              //new, but same position
              p.fill(160,255,230)
              // p.noFill()
              p.ellipse(pos.x, pos.y, pos.r*2, pos.r*2);
              p.text(`blob[${player_id}]:  = ${pos.r}`, pos.x + pos.r, pos.y)
            }
          } 

          
        }
      }

      // if(other_vel[player_id]){
        
      //   // var newvel = new p5.Vector(p.mouseX-p.width/2, p.mouseY-p.height/2);
      //   // newvel.setMag(3);
      //   // this.vel.lerp(newvel, 0.2);
      //   // this.pos.add(this.vel);

      //   p.fill('red')
      //   p.ellipse(pos.x, pos.y, pos.r*2, pos.r*2);
      //   p.text(`blob[${player_id}]:  = ${pos.r}`, pos.x + pos.r, pos.y)
      // }else{
      //   p.fill('blue')
      //   p.ellipse(pos.x, pos.y, pos.r*2, pos.r*2);
      //   p.text(`blobza[${player_id}]:  = ${pos.r}`, pos.x + pos.r, pos.y)
      // }
      
    }

    other_last_pos = gamedata;
  }

} //end draw

function drawArrow(base, vec, myColor, strokeW=3) {
  p.push();
  p.stroke(myColor);
  p.strokeWeight(strokeW);
  p.fill(myColor);
  p.translate(base.x, base.y);
  p.line(0, 0, vec.x, vec.y);
  p.rotate(vec.heading());
  var arrowSize = 7;
  p.translate(vec.mag() - arrowSize, 0);
  p.triangle(0, arrowSize / 2, 0, -arrowSize / 2, arrowSize, 0);
  p.pop();
}


} //end sketch definition



var myp5 = new p5(s);

