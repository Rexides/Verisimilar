local currentSubCategory
local filter="";
local filterList={};


function VerisimilarGM:ShowIconChooser(returnHandler)
	VGMIconChooser:Show()
	VGMIconChooser.returnHandler=returnHandler;
end


function VerisimilarGM:UpdateIconChooser()
	local offset=FauxScrollFrame_GetOffset(VGMIconChooserScrollFrame);
	local index=((offset) * 5);
	local iconList=nil;
	for i=1,20 do
		
		local button=getglobal("VGMIconChooserButton"..i);
		
		if(currentSubCategory)then
			iconList=VGM_StockIcons[currentSubCategory];
		else
			iconList=filterList;
		end
		if(iconList[i+index]~=nil)then
			
			SetItemButtonTexture(button,"Interface\\Icons\\"..iconList[i+index]);
			button.iconName=iconList[i+index];
			button:Show();
		else
			button:Hide();
		end
	end
	
	FauxScrollFrame_Update(VGMIconChooserScrollFrame, ceil(#iconList / 5) , 4, 36 );
	
end

function VerisimilarGM:InitializeIconFilter()
	currentSubCategory="Spell";
	UIDropDownMenu_SetText(VGMIconChooserCurrentSubCategory, currentSubCategory);
	VGMIconChooserCurrentSubCategoryButton:HookScript("OnClick",VerisimilarGM.OncurrentSubCategoryButtonClick);
		
end

function VerisimilarGM:OncurrentSubCategoryButtonClick()
	local dewdrop = AceLibrary("Dewdrop-2.0")
	dewdrop:Open(VGMIconChooserCurrentSubCategoryButton,
				'children',	function()
									local menuTable={};
									for category,subCategories in pairs(VGM_IconSubcategories) do
										local categoryTable={	text=category,
																hasArrow=true,
																subMenu={}
															}
										for i=1,#subCategories do
											tinsert(categoryTable.subMenu,{	text=subCategories[i],
																			checked=subCategories[i]==currentSubCategory,
																			func=VerisimilarGM.SetCurrentSubCategory,
																			arg1=VerisimilarGM,
																			arg2=subCategories[i],
																			closeWhenClicked=true
																			});
										end
										tinsert(menuTable,categoryTable);
									end
									tinsert(menuTable,{	text="Filter",
														hasArrow=true,
														hasEditBox=true,
														editBoxText="",
														editBoxFunc=VerisimilarGM.SetIconFilter,
														editBoxArg1=VerisimilarGM,
														});
									dewdrop:FeedTable(menuTable);
								end
				
				)
end

function VerisimilarGM:SetIconFilter(filterText)
	currentSubCategory=nil;
	filter=strlower(filterText);
	filterList={};
	for _,subCategory in pairs(VGM_StockIcons)do
		for i=1,#subCategory do
			if(string.find(strlower(subCategory[i]), filter))then
				tinsert(filterList,subCategory[i]);
			end
		end
	end
	UIDropDownMenu_SetText(VGMIconChooserCurrentSubCategory, filterText);
	VGMIconChooserScrollFrameScrollBar:SetValue(0);
	FauxScrollFrame_Update(VGMIconChooserScrollFrame, ceil(#filterList / 5) , 4, 36 );
	VerisimilarGM:UpdateIconChooser()
end

function VerisimilarGM:SetCurrentSubCategory(SubCategory)
	currentSubCategory=SubCategory;
	UIDropDownMenu_SetText(VGMIconChooserCurrentSubCategory, currentSubCategory);
	VGMIconChooserScrollFrameScrollBar:SetValue(0);
	FauxScrollFrame_Update(VGMIconChooserScrollFrame, ceil(#VGM_StockIcons[currentSubCategory] / 5) , 4, 36 );
	VerisimilarGM:UpdateIconChooser()
end


