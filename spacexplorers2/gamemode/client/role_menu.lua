-- The list of all roles
-- Please, do not change the ids of the roles, it can broke something

hook.Add("se_event_open_role_menu", "se_open_role_menu", function()
  -- Please, use panel_size to change resolution
  local panel_size = {600, 600}
  -- Represents curret choosen role
  local choosed_role = roles.Captain

  local role_choose_window = vgui.Create("SEFrame")
  role_choose_window:SetSize( panel_size[1], panel_size[2] )
  role_choose_window:SetPos(ScrW() - (panel_size[1] + 100), (ScrH() - panel_size[2]) / 2)
  role_choose_window:ShowCloseButton( false)
  role_choose_window:SetDraggable( false )
  -- This is the thing in left corner that shows how you looks like
  local player_view = vgui.Create( "DModelPanel" )
  player_view:SetWide(ScrW() - (panel_size[1] + 100))
  player_view:Dock( LEFT )
  player_view:SetModel( LocalPlayer():GetModel() )
  -- This is for classes buttons
  local buttons_frame = vgui.Create("DIconLayout", role_choose_window)
  buttons_frame:Dock(TOP)
  buttons_frame:SetSpaceY( 10 )
  buttons_frame:SetSpaceX( 10 )
  -- The description of the role
  local role_desc = vgui.Create( "DLabel", role_choose_window )
  role_desc:Dock( FILL )
  role_desc:SetAutoStretchVertical( true )
  role_desc:SetWrap(true)
  role_desc:SetText( "" )
  role_desc:SetFont( "se_text_font" )
  -- As we use 2 different panels for role_choose_window and player_view we have to remove player_view after role_choose_window is getting closed
  function role_choose_window:OnClose()
    player_view:Remove()
  end
  function role_choose_window:OnRemove()
    player_view:Remove()
  end
  -- Use this function to change role
  local function choose_role(role)
    player_view:SetModel( role.model )
    role_desc:SetText( role.desc )
    choosed_role = role
  end
  -- Add roles buttons in buttons_frame thing
  for k, v in pairs(roles) do
    local role_button = buttons_frame:Add("SERoleButton")
    role_button:SetSize((panel_size[1] - (table.Count(roles) * 11)) / table.Count(roles), 100)
    role_button.color = v.color
    role_button.ClassText = k
    role_button.Icon = k
    role_button.DoClick = function()
      -- If we click, we change role
      choose_role(v)
    end
  end

  local apply_button = vgui.Create( "SEButton", role_choose_window )
  apply_button:SetTall( 50 )
  apply_button:Dock(BOTTOM)
  apply_button:SetText( "Apply" )
  apply_button.color = Color(40, 200, 40)
  function apply_button:OnMousePressed()
    -- I decided to not use events here, because writing 1 value as a table is stupid.
  	net.Start("se_choose_role")
    -- We use 4 bits, so we can have up to 16 roles
    net.WriteInt(choosed_role.id, 4)
    net.SendToServer()
    -- Close the window
    role_choose_window:Close()
  end

  -- As user didn't click anything, we have to do it instead
  choose_role(choosed_role)
end)
