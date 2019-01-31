-- NOTE: I really think that this is the shittiest part of the code. But it works

local se_frames_list = {}

-- Draw all elements of the frame
function se_draw_frame(frame)
  -- Iter over all buttons
  for k, v in pairs(frame.buttons) do
    -- Draw button
    se_draw_simple_button(frame, k)
  end
end

function se_draw_simple_button(frame, id)
  -- Get button
  local button = frame.buttons[id]
  -- Get color and text, set to default if nil
  local color = button.color or Color(0, 0, 60)
  local text = button.text or ""
  if !button then return end
  -- If hovered - change color
  if button.hovered == true then color = Color(color.r + 20, color.g + 20, color.b + 20) end
  -- Draw button
  draw.RoundedBox( 2, button.pos[1], button.pos[2], button.w, button.h, color )
  draw.SimpleText( text, "se_text_font", button.pos[1], button.pos[2], Color( 255, 255, 255, 255 ))
end

-- Function to construct frame
function se_construct_frame(w, h, pos, angle, scale)
  -- Check args, if nil set to default
  local w = w or 0
  local h = h or 0
  local pos = pos or Vector()
  local angle = angle or Angle()
  local scale = scale or 1
  -- Construct frame
  local frame = {
    pos = pos,
    ang = angle,
    size = {w, h},
    buttons = {},
    scale = scale
  }
  return frame
end
-- Function to construct button
function se_construct_button(pos, w, h)
  local button = {
    pos = pos,
    w = w,
    h = h
  }
  return button
end
-- Function to add button into the frame
function se_frame_add_button(frame, button, id)
  frame.buttons[id] = button
end
-- Check if given position is inside the range(Used for buttons)
function se_pos_in_range(pos_a, pos_b, w, h)
  if pos_a[1] > pos_b[1] and pos_a[1] < (pos_b[1] + w) then
    if pos_a[2] > pos_b[2] and pos_a[2] < (pos_b[2] + h) then
      return true
    end
  end
  return false
end

-- Update frame
function se_update_frame(frame)
  -- Get cursor pos
  local cur_pos = se_frame_cur_pos(frame)
  -- If cursor pos is nil, return
  if !cur_pos then return end
  -- Set hovered
  for k, v in pairs(frame.buttons) do
    v.hovered = se_pos_in_range(cur_pos, v.pos, v.w, v.h) or false
  end
  -- Input check

  -- Cooldown, if nil set to 0
  se_gui_input_cooldown = se_gui_input_cooldown or 0
  -- If E is pressed and cooldown is lower than curtime
  if (input.IsKeyDown( KEY_E ) or input.IsMouseDown(MOUSE_LEFT)) and CurTime() > se_gui_input_cooldown then
    -- Add cooldown
    se_gui_input_cooldown = CurTime() + 0.2
    -- Iter over buttons
    for nm, button in pairs(frame.buttons) do
      -- If button is hovered and hoodname is difined
      if button.hovered and button.hook_name then
        -- Then run se_button_press hook
        hook.Run("se_button_press_"..button.hook_name, unpack(button.args or {}))
      end
    end
  end
end
-- Get cursor pos of the frame
function se_frame_cur_pos(frame)
  -- Get position and aim vector
  local position = LocalPlayer():EyePos()
  local direction = LocalPlayer():GetAimVector()
  -- Get frame offset
  local frame_position = frame.pos
  -- Get frame normal
  local normal = frame.ang:Up()
  -- Check intersection with frame
  local intersection_result = util.IntersectRayWithPlane( position, direction, frame_position, normal )
  if !intersection_result then return end
  -- Translate it into x, y coords
  local cursor_pos = WorldToLocal(intersection_result, Angle(0,0,0), frame_position, frame.ang) / frame.scale
  cursor_pos.y = -cursor_pos.y
  -- Check if cursor inside frame
  if cursor_pos.x > frame.size[1] or cursor_pos.x < 0 then return end
  if cursor_pos.y > frame.size[2] or cursor_pos.y < 0 then return end
  -- Return x, y
  return {cursor_pos.x, cursor_pos.y}
end
