<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<UiMod name="MegaphonePlusPlus" version="1.0" date="26/05/2020" >

		<Author name="Tim Neill" email="kinghfb@gmail.com" />
		<Author name="kinghfb" version= "1.0"/>
		<Description text="Announces group leader's texts on screen. Never miss a command!" />
		<VersionSettings gameVersion="1.4.1" windowsVersion="1.0" savedVariablesVersion="1.0" />

		<Dependencies>
			<Dependency name="EA_ChatWindow" />
			<Dependency name="LibSlash"/>
			<Dependency name="EASystem_Utils"/>
			<Dependency name="EASystem_WindowUtils"/>
		</Dependencies>
		
		<Files>
			<File name="MegaphonePlusPlus.lua" />
			<File name="MegaphonePlusPlus.xml" />

            <!-- <File name="Textures/EA_ScenarioSummary01_d5.xml" /> -->
		</Files>

		<SavedVariables>
			<SavedVariable name="Megaphone.Settings" />
		</SavedVariables>
		
		<OnInitialize>
			<CallFunction name="Megaphone.Initialize" />
		</OnInitialize>
		
		<OnShutdown>
			<CallFunction name="Megaphone.OnShutdown" />
		</OnShutdown>

		<OnUpdate/>

		<WARInfo>
			<Categories>
				<Category name="RVR" />
				<Category name="GROUPING" />
				<Category name="COMBAT" />
			</Categories>
			<Careers>
				<Career name="BLACKGUARD" />
				<Career name="WITCH_ELF" />
				<Career name="DISCIPLE" />
				<Career name="SORCERER" />
				<Career name="IRON_BREAKER" />
				<Career name="SLAYER" />
				<Career name="RUNE_PRIEST" />
				<Career name="ENGINEER" />
				<Career name="BLACK_ORC" />
				<Career name="CHOPPA" />
				<Career name="SHAMAN" />
				<Career name="SQUIG_HERDER" />
				<Career name="WITCH_HUNTER" />
				<Career name="KNIGHT" />
				<Career name="BRIGHT_WIZARD" />
				<Career name="WARRIOR_PRIEST" />
				<Career name="CHOSEN" />
				<Career name="MARAUDER" />
				<Career name="ZEALOT" />
				<Career name="MAGUS" />
				<Career name="SWORDMASTER" />
				<Career name="SHADOW_WARRIOR" />
				<Career name="WHITE_LION" />
				<Career name="ARCHMAGE" />
			</Careers>
		</WARInfo>
	</UiMod>
</ModuleFile>