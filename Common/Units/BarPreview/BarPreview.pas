unit BarPreview;

interface

procedure CreateBarPreview(ABitmap : TBitmap32; pSkin,pScheme : String; Width : integer);

implementation

uses SharpApi, SharpThemeApi, Math, GR32, JvSimpleXML, BarForm;

procedure CreateBarPreview(ABitmap : TBitmap32; pSkin,pScheme : String; Width : integer);
var
  BarWnd: TBarWnd;
  Dir : String;
  skinfile : String;
  schemefile : String;
  colorvalue : String;
  colorint   : integer;
  XML : TJvSimpleXML;
  n : integer;
begin
  try
    XML := TJvSimpleXML.Create(nil);

    BarWnd := TBarWnd.Create(nil);
    Dir := SharpApi.GetSharpeDirectory;
    skinfile := Dir + 'Skins\' + pSkin + '\skin.xml';
    if FileExists(skinfile) then BarWnd.SharpESkin1.LoadFromXmlFile(skinfile);
    schemefile := Dir + 'Skins\' + pSkin + '\Schemes\' + pScheme;
    if not FileExists(schemefile) then schemefile := Dir + 'Skins\' + pSkin + '\scheme.xml';
    if FileExists(schemefile) then
    try
      XML.LoadFromFile(schemefile);
      for n := 0 to XML.Root.Items.Count - 1 do
          with XML.Root.Items.Item[n].Items do
          begin
            if ItemNamed['Default'] <> nil then
               colorvalue := Value('Default','0')
               else colorvalue := Value('Color','0');
            colorint := SharpThemeApi.ParseColor(PChar(colorvalue));
            BarWnd.SharpEScheme1.AddColor('temp',Value('Tag','temp'),'temp',colorint);
          end;
    except
    end;

    BarWnd.Left := -100;
    BarWnd.Top := -100;

    BarWnd.SharpEBar1.UpdateSkin;
    ShowWindow(BarWnd.SharpEBar1.abackground.handle,SW_HIDE);
    ABitmap.SetSize(max(width,1),BarWnd.SkinManager.Skin.BarSkin.SkinDim.HeightAsInt);
    ABitmap.Clear(color32(0,0,0,0));
    BarWnd.SharpEBar1.VertPos := vpTop;
    BarWnd.SharpEBar1.UpdateSkin;
    BarWnd.SharpEBar1.Skin.DrawTo(ABitmap,0,0);
    BarWnd.SharpEBar1.VertPos := vpBottom;
    BarWnd.SharpEBar1.Throbber.UpdateSkin;
    BarWnd.SharpEBar1.Throbber.Skin.DrawTo(ABitmap,
                                           BarWnd.SkinManager.Skin.BarSkin.ThDim.XAsInt,
                                           BarWnd.SkinManager.Skin.BarSkin.ThDim.YAsInt);
  finally
    XML.Free;
    FreeAndNil(barWnd);
  end;
end;

end.
