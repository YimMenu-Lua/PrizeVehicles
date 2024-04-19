local vehicle_prizes_tab = gui.get_tab("Vehicle Prizes")

local vehicle_classes = {
	"Compacts",
	"Sedans",
	"SUVs",
	"Coupes",
	"Muscle",
	"Sports Classics",
	"Sports",
	"Super",
	"Motorcycles",
	"Off-Road",
	"Industrial",
	"Utility",
	"Vans",
	"Cycles",
	"Boats",
	"Helicopters",
	"Planes",
	"Service",
	"Emergency",
	"Military",
	"Commercial",
	"Trains",
	"Open Wheels"
}

local vehicle_prizes = {
	"Podium",
	"Prize Ride",
	"Test Track 1",
	"Test Track 2",
	"Test Track 3",
	"Luxury Autos 1",
	"Luxury Autos 2",
	"Simeon 1",
	"Simeon 2",
	"Simeon 3",
	"Simeon 4",
	"Simeon 5"
}

local selected_prize = 0
local selected_class = 0
local is_typing      = false
local vehicle_editor = false
local filter_text    = ""
local vehicle_name   = ""
local all_vehicles   = vehicles.get_all_vehicles_by_class(vehicle_classes[selected_class + 1])

local casino_prize_vehicle      = ""
local car_meet_vehicle          = ""
local promo_test_drive_vehicle  = {}
local luxury_showcase_vehicle   = {}
local simeon_test_drive_vehicle = {}

local function set_prize_vehicle(vehicle_name)
	local tunable = ""
	
	if selected_prize == 0 then
		tunable = "CASINO_PRIZE_VEHICLE_MODEL_HASH"
	elseif selected_prize == 1 then
		tunable = "CAR_MEET_PRIZE_VEHICLE_MODEL_HASH"
	elseif selected_prize == 2 then
		tunable = "PROMO_TEST_DRIVE_VEHICLE_1_MODEL_HASH"
	elseif selected_prize == 3 then
		tunable = "PROMO_TEST_DRIVE_VEHICLE_2_MODEL_HASH"
	elseif selected_prize == 4 then
		tunable = "PROMO_TEST_DRIVE_VEHICLE_3_MODEL_HASH"
	elseif selected_prize == 5 then
		tunable = "LUXURY_SHOWCASE_VEHICLE_1_MODEL_HASH"
	elseif selected_prize == 6 then
		tunable = "LUXURY_SHOWCASE_VEHICLE_2_MODEL_HASH"
	elseif selected_prize == 7 then
		tunable = "SIMEON_TEST_DRIVE_VEHICLE_1_MODEL_HASH"
	elseif selected_prize == 8 then
		tunable = "SIMEON_TEST_DRIVE_VEHICLE_2_MODEL_HASH"
	elseif selected_prize == 9 then
		tunable = "SIMEON_TEST_DRIVE_VEHICLE_3_MODEL_HASH"
	elseif selected_prize == 10 then
		tunable = "SIMEON_TEST_DRIVE_VEHICLE_4_MODEL_HASH"
	elseif selected_prize == 11 then
		tunable = "SIMEON_TEST_DRIVE_VEHICLE_5_MODEL_HASH"
	end
    
    if tunable ~= "" then
        tunables.set_int(tunable, joaat(vehicle_name))
    end
end

local function get_casino_prize_vehicle()
	return tunables.get_int("CASINO_PRIZE_VEHICLE_MODEL_HASH")
end

local function get_car_meet_prize_vehicle()
	return tunables.get_int("CAR_MEET_PRIZE_VEHICLE_MODEL_HASH")
end

local function get_promo_test_drive_vehicle(index)
	return tunables.get_int("PROMO_TEST_DRIVE_VEHICLE_" .. tostring(index) .. "_MODEL_HASH")
end

local function get_luxury_showcase_vehicle(index)
	return tunables.get_int("LUXURY_SHOWCASE_VEHICLE_" .. tostring(index) .. "_MODEL_HASH")
end

local function get_simeon_test_drive_vehicle(index)
	return tunables.get_int("SIMEON_TEST_DRIVE_VEHICLE_" .. tostring(index) .. "_MODEL_HASH")
end

local function render_vehicle_editor()
	ImGui.SetNextWindowSize(700, 450)
	ImGui.OpenPopup("Vehicle Editor")
	
	if ImGui.BeginPopupModal("Vehicle Editor", vehicle_editor, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoCollapse | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.Modal) then
		selected_prize = ImGui.Combo("Select Prize Type", selected_prize, vehicle_prizes, #vehicle_prizes)
		
		selected_class, clicked = ImGui.Combo("Select Class", selected_class, vehicle_classes, #vehicle_classes)
		
		if clicked then
			all_vehicles = vehicles.get_all_vehicles_by_class(vehicle_classes[selected_class + 1])
			filter_text  = ""
			vehicle_name = ""
		end
		
		filter_text = ImGui.InputText("Vehicle Name", filter_text, 100)
		if ImGui.IsItemActive() then
			is_typing = true
		else
			is_typing = false
		end
		
		if ImGui.BeginListBox("##vehicles", 450, 200) then
			for index, item in ipairs(all_vehicles) do
				local display_name = vehicles.get_vehicle_display_name(item)
				if string.find(display_name:lower(), filter_text:lower()) then
					if ImGui.Selectable(display_name) then
						filter_text  = display_name
						vehicle_name = item
					end
				end
			end
			ImGui.EndListBox()
		end
		
		if ImGui.Button("Set Vehicle") then
			local is_vehicle_valid = vehicles.get_vehicle_display_name(vehicle_name) ~= ""
			
			if is_vehicle_valid then
				set_prize_vehicle(vehicle_name)
			else
				gui.show_error("Vehicle Prizes", "Invalid vehicle.")
			end
		end

		ImGui.SameLine()

		if ImGui.Button("Close") then
			selected_prize = 0
			selected_class = 0
			filter_text    = ""
			vehicle_name   = ""
			vehicle_editor = false
			ImGui.CloseCurrentPopup()
		end

		ImGui.EndPopup()
	end
end

script.register_looped("Vehicle Prizes", function()
	casino_prize_vehicle         = vehicles.get_vehicle_display_name(get_casino_prize_vehicle())
	car_meet_vehicle             = vehicles.get_vehicle_display_name(get_car_meet_prize_vehicle())
	promo_test_drive_vehicle[1]  = vehicles.get_vehicle_display_name(get_promo_test_drive_vehicle(1))
	promo_test_drive_vehicle[2]  = vehicles.get_vehicle_display_name(get_promo_test_drive_vehicle(2))
	promo_test_drive_vehicle[3]  = vehicles.get_vehicle_display_name(get_promo_test_drive_vehicle(3))
	luxury_showcase_vehicle[1]   = vehicles.get_vehicle_display_name(get_luxury_showcase_vehicle(1))
	luxury_showcase_vehicle[2]   = vehicles.get_vehicle_display_name(get_luxury_showcase_vehicle(2))
	simeon_test_drive_vehicle[1] = vehicles.get_vehicle_display_name(get_simeon_test_drive_vehicle(1))
	simeon_test_drive_vehicle[2] = vehicles.get_vehicle_display_name(get_simeon_test_drive_vehicle(2))
	simeon_test_drive_vehicle[3] = vehicles.get_vehicle_display_name(get_simeon_test_drive_vehicle(3))
	simeon_test_drive_vehicle[4] = vehicles.get_vehicle_display_name(get_simeon_test_drive_vehicle(4))
	simeon_test_drive_vehicle[5] = vehicles.get_vehicle_display_name(get_simeon_test_drive_vehicle(5))

	if is_typing then
		PAD.DISABLE_ALL_CONTROL_ACTIONS(0)
	end	
end)

vehicle_prizes_tab:add_imgui(function()
	if vehicle_editor then
		render_vehicle_editor()
	end

	if ImGui.TreeNode("The Lucky Wheel Podium") then
		ImGui.Text("- " .. casino_prize_vehicle)
		
		if ImGui.Button("Teleport##tp_casino") then
			script.run_in_fiber(function()
				local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(679))
				PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
			end)
		end
		
		ImGui.Separator()
		ImGui.TreePop()
	end
	
	if ImGui.TreeNode("LS Car Meet Prize Ride") then
		ImGui.Text("- " .. car_meet_vehicle)
		
		if ImGui.Button("Teleport##tp_lscm") then
			script.run_in_fiber(function()
				local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(777))
				PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
			end)
		end
		
		ImGui.SameLine()
		
		if ImGui.Button("Complete Challenge") then
			script.run_in_fiber(function()
				stats.set_bool("MPX_CARMEET_PV_CHLLGE_CMPLT", true)
				stats.set_bool("MPX_CARMEET_PV_CLMED", false)
				gui.show_message("Vehicle Prizes", "Done. If you are in LSCM, re-enter to collect the prize.")
			end)
		end
		
		ImGui.Separator()
		ImGui.TreePop()
	end
	
	if ImGui.TreeNode("LS Car Meet Test Track") then
		ImGui.Text("- " .. promo_test_drive_vehicle[1])
		ImGui.Text("- " .. promo_test_drive_vehicle[2])
		ImGui.Text("- " .. promo_test_drive_vehicle[3])
		
		if ImGui.Button("Teleport##tp_test") then
			script.run_in_fiber(function()
				local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(777))
				PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
			end)
		end
		
		ImGui.Separator()
		ImGui.TreePop()
	end
	
	if ImGui.TreeNode("Luxury Autos") then
		ImGui.Text("- " .. luxury_showcase_vehicle[1])
		ImGui.Text("- " .. luxury_showcase_vehicle[2])
		
		if ImGui.Button("Teleport##tp_luxury") then
			script.run_in_fiber(function()
				local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(830))
				PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
			end)
		end
		
		ImGui.Separator()
		ImGui.TreePop()
	end
	
	if ImGui.TreeNode("Premium Deluxe Motorsport") then
		ImGui.Text("- " .. simeon_test_drive_vehicle[1])
		ImGui.Text("- " .. simeon_test_drive_vehicle[2])
		ImGui.Text("- " .. simeon_test_drive_vehicle[3])
		ImGui.Text("- " .. simeon_test_drive_vehicle[4])
		ImGui.Text("- " .. simeon_test_drive_vehicle[5])
		
		if ImGui.Button("Teleport##tp_simeon") then
			script.run_in_fiber(function()
				local coords = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(832))
				PED.SET_PED_COORDS_KEEP_VEHICLE(self.get_ped(), coords.x, coords.y, coords.z)
			end)
		end
		
		ImGui.Separator()
		ImGui.TreePop()
	end
	
	if ImGui.Button("Edit Vehicles") then
		vehicle_editor = true
	end
end)