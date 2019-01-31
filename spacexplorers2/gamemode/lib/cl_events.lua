net.Receive("se_event", function(len)
  local event = net.ReadString()
  local compress = net.ReadBool()
  local args  = {}
  if compress then
    local len = net.ReadInt(32)
    args  = net.ReadData(len)
    args = util.JSONToTable( util.Decompress( args ) )
  else
    args  = net.ReadTable()
  end
  hook.Run("se_event_"..event, unpack(args))
end)


function se_send_event(event, args)
  net.Start("se_event")
  net.WriteString(event)
  net.WriteTable(args)
  net.SendToServer()
end
