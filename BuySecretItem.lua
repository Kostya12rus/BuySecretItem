local BuySecretItem = {}
BuySecretItem.optionEnable = Menu.AddOption({"Utility","Buy Secret Item"}, "Activate", "")
BuySecretItem.optionKey = Menu.AddKeyOption({"Utility","Buy Secret Item"},"Key for buy and drop",Enum.ButtonCode.KEY_NONE)

function BuySecretItem.OnUpdate()
	if not Menu.IsEnabled(BuySecretItem.optionEnable) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end 
	if buyitem and trigerTimes <= GameRules.GetGameTime() then
		if not BuySecretItem.FindItem() or not BuySecretItem.FindShop() then
			buyitem = false
			return
		end
		if not BuySecretItem.FindItemInStash() then
			local freeslot = 9 
			for index_item = 0, 8 do
				local item = NPC.GetItemByIndex(myHero, index_item)
				if item and Entity.IsAbility(item) then
					local itemName = Ability.GetName(item)
					for _,nameitem in pairs(itemlist) do
						if itemName == nameitem then
							BuySecretItem.MoveItemToSlot(item, freeslot)
							freeslot = freeslot + 1
							if freeslot > 14 then
								return
							end
						end
					end
				end
			end
		else
			for index_item = 9, 14 do
				local item = NPC.GetItemByIndex(myHero, index_item)
				if item and Entity.IsAbility(item) then
					local itemName = Ability.GetName(item)
					for _,nameitem in pairs(itemlist) do
						if itemName == nameitem and trigerTimes <= GameRules.GetGameTime() then
							BuySecretItem.DropItem(item)
							trigerTimes = GameRules.GetGameTime() + 0.1
						end
					end
				end
			end
		end
	end
	if Menu.IsKeyDownOnce(BuySecretItem.optionKey) then
		for i = 21,27 do BuySecretItem.BuyItem(1000+i) end
		trigerTimes = GameRules.GetGameTime() + 0.5
		buyitem = true
	end
end

function BuySecretItem.FindShop()
	for _,npcs in pairs(NPCs.GetAll()) do
		if npcs and NPC.GetUnitType(npcs) == Enum.UnitType.DOTA_UNIT_SHOPKEEP then
			if NPC.IsEntityInRange(Heroes.GetLocal(),npcs,700) then
				return true
			end
		end
	end
	return false
end

function BuySecretItem.FindItemInStash()
	for index_item = 9, 14 do
		local item = NPC.GetItemByIndex(Heroes.GetLocal(), index_item)
		if item and Entity.IsAbility(item) then
			local itemName = Ability.GetName(item)
			for _,nameitem in pairs(itemlist) do
				if itemName == nameitem then
					return true
				end
			end
		end
	end
	return false
end

function BuySecretItem.FindItem()
	for index_item = 0, 14 do
		local item = NPC.GetItemByIndex(Heroes.GetLocal(), index_item)
		if item then
			local itemName = Ability.GetName(item)
			for _,nameitem in pairs(itemlist) do
				if itemName == nameitem then
					return true
				end
			end
		end
	end
	return false
end

function BuySecretItem.MoveItemToSlot(item, slot_index)
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_ITEM, slot_index, Vector(0, 0, 0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, Heroes.GetLocal())
end

function BuySecretItem.DropItem(item)
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH, item, Vector(0, 0, 0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, Heroes.GetLocal())
end

function BuySecretItem.BuyItem(item)
	Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PURCHASE_ITEM, item, Vector(0, 0, 0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, Heroes.GetLocal(), false, true)
end

function BuySecretItem.init()
trigerTimes = 0
buyitem = false
itemlist = {
  "item_river_painter",
  "item_river_painter2",
  "item_river_painter3",
  "item_river_painter4",
  "item_river_painter5",
  "item_river_painter6",
  "item_river_painter7"	
}
end
function BuySecretItem.OnGameStart()
	BuySecretItem.init()
end
BuySecretItem.init()

return BuySecretItem