/// room_goto_next_time()
var t = current_time + argument0;
while t > 0 {t-=1;}
if t = 0 {room_goto_next()}
