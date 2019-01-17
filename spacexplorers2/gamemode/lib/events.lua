-- Events are made for messages with no data, or messages where you cannot compress data(Like using 8 bits for ints instead of 32), or for messages where you are using WriteTable.
-- This means that events is ideal for updating ship info, dialoges, hits, (Wow, only when I wrote this I've got that it gets a lot usage)

-- Receive event and make hook call
net.Receive("se_event", function()
  local event = net.ReadString()
  local args  = net.ReadTable()
  -- We also use unpack to transform table to arguments
  hook.Run("se_event_"..event, unpack(args))
end)

-- Send event to the player. If ply is not specefied, then it will broadcast.
function se_send_event(event, args, ply)
  net.Start("se_event")
  net.WriteString(event)
  net.WriteTable(args)
  if ply != nil then
    net.Send(ply)
  else
    net.Broadcast()
  end
end
