const express=require('express')
const app=express();
const socket=require('socket.io')
const mongoose=require('mongoose')
const http=require('http')

//importing the mongo schema
const Room=require('./roomschema')

var server=http.createServer(app)
var io=socket(server)
app.use(express.json())
const db="Your Db"
mongoose.connect(db).then(
()=>{
    console.log("Connection Sucessful")
    
}
).catch((e)=>{
    console.log(e);
})
io.on("connection",(socket)=>{
console.log("connected");
socket.on("createRoom",async({nickname})=>{
    //console.log("eventoccured")
    console.log(nickname)
    try{
    let room=Room()
    let player={
        socketID: socket.id,
        nickname,
        playerType: "X",
    }
    room.players.push(player)
    room.turn=player
    room=await room.save()
    const roomid=room._id.toString()
    socket.join(roomid)
    io.to(roomid).emit('createRoomSucess',room);
    }
    catch(e){
    console.log(e)
    }})
socket.on("joinRoom",async({nickname,roomId})=>{
console.log(nickname,roomId)
try{
    if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("errorOccurred", "Please enter a valid room ID.");
        return;
      }
      let room = await Room.findById(roomId);

      if (room.isJoin) {
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        room.isJoin = false;
        room = await room.save();
        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room);
      } else {
        socket.emit(
          "errorOccurred",
          "The game is in progress, try again later."
        );
      }
}
catch(e){
    console.log(e);
}

})
socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);

      let choice = room.turn.playerType; // x or o
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      io.to(roomId).emit("tapped", {
        index,
        choice,
        room,
      });
    } catch (e) {
      console.log(e);
    }
  })

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let player = room.players.find(
        (playerr) => playerr.socketID == winnerSocketId
      );
      player.points += 1;
      console.log(player.points);
      room.currentRound+=1
      room = await room.save();

      if (room.currentRound > room.maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointIncrease", player);
      }
    } catch (e) {
      console.log(e);
    }
  })

})


// ip address got through ipconfig on windows and ifconfig on linux
server.listen(3000,"0.0.0.0",(req,res)=>{
    console.log("Server at 0.0.0.0:3000");
})



