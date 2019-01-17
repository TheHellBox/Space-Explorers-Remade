net.Receive("se_event", function()
  local event = net.ReadString()
  local args  = net.ReadTable()
  hook.Run("se_event_"..event, unpack(args))
end)


function se_send_event(event, args)
  net.Start("se_event")
  net.WriteString(event)
  net.WriteTable(args)
  net.SendToServer()
end
