

if(window.location.pathname !== '/grid'){
  throw new Error("bad path")
}


import {Socket} from "phoenix"

let socket_grid = new Socket("/socket", {params: {token: window.userToken}})
socket_grid.connect()

let channel = socket_grid.channel("grid:lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("Joined Grid Channel successfully", resp)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

  
//channel.on("heartbeat", payload => {
//
//)



var s = function(p) {

  p.mouseReleased = function () {
    console.log("released")
    //channel.push("new_msg", {body: "pressed"})
    channel.push("new_pos",
        {
          body: {
            pos_x: blob.pos.x,
            pos_y: blob.pos.y,
            radius: blob.r
          }
        })
  }

  function Blob3(x, y, r, id=null) {
    console.log("building blob")
    this.id = id;
    this.color = 255;
    this.pos = new p5.Vector(x, y);
    this.r = r;
    this.vel = new p5.Vector(0, 0);

    this.update = function () {

      if (p.mouseIsPressed) {
        var newvel = new p5.Vector(p.mouseX - p.width / 2, p.mouseY - p.height / 2);
        newvel.setMag(3);
        this.vel.lerp(newvel, 0.2);
        this.pos.add(this.vel);
      }

    }

    this.eats = function (other) {
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

    this.show = function () {
      p.fill(this.color, this.color, 255);
      p.ellipse(this.pos.x, this.pos.y, this.r * 2, this.r * 2);
    }
  }

  p.setup = function () {
    var c = p.createCanvas(600, 600);
    c.parent("sketchContainer")

  }

  p.draw = function () {
    p.background(100);
    p.textSize(20);
    p.translate(p.width / 2, p.height / 2);

    p.fill(160, 255, 160)


  }
}

var myp5 = new p5(s);

