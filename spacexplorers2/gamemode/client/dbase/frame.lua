local PANEL = {}

function PANEL:Init()
  self:SetDraggable( true )
  self:MakePopup()
  self:SetTitle( "" )
end

function PANEL:Paint( w, h )
  draw.RoundedBox( 5, 0, 0, w, h, Color(50, 50, 50))
end

vgui.Register( "SEFrame", PANEL, "DFrame" )
