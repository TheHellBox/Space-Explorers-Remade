-- Add line to the terminal.
hook.Add("se_event_term_add_line", function(terminal, text)
  -- Check if terminal is valid
  if IsValid(terminal) then
    -- And add text then
    terminal:AddLine(text)
  end
end)
