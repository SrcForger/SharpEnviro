unit uTwitter;

interface

uses
  windows,
  messages,
  SysUtils,
  classes,
  Variants,
  Forms,
  Controls,
  ContNrs,
  StrUtils,
  GR32,
  JclSimpleXml,
  IdHTTP,
  uSharpXMLUtils,
  SharpImageUtils, SharpAPI;

type
  TTwitterFeed = class
    public
      // Feed related
      FeedID : integer;
      Text, Time : string;

      // User related
      UserID : integer;
      UserName, UserScreenName : String;
      UserImage : TBitmap32;
  end;

  TTwitter = class
  protected
    procedure SaveToken;

    function GetFeedCount: integer;
    function GetFeed(i: integer): TTwitterFeed;

    procedure LoadImage(var vinfo : TTwitterFeed; url: string);

  private
    FSavePath : string;
    FTimeLine : TObjectList;
    FAuthorized : boolean;
    
  public
    // savePath is only the path to the dir (including last \), not the filename
    constructor Create(savePath : string = '');
    destructor Destroy; override;

    // Loads twitter page to accept SharpEnviro
    function LoadPin: integer;

    // Verify the pin you receive from LoadPin
    function VerifyPin(pin: string; ShouldLoadTimeline: boolean = true): integer;

    // Load Home timeline
    procedure LoadTimeLine;

    // Set new status
    function UpdateStatus(newStatus : string): integer;

    // See if we are authorized (could be used right after .Create)
    property Authorized: boolean read FAuthorized;

    // Get the number of feeds
    property FeedCount: integer read GetFeedCount;

    // Retrieve a feed
    property Feed[i: integer]: TTwitterFeed read GetFeed;

  end;

  // Imported functions
  function SharpTwitterAuthorize(token : PChar; tokenSecret : PChar; name : PChar): boolean; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterAuthorize';
  function SharpTwitterLoadPin: integer; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterLoadPin';
  function SharpTwitterVerifyPin(pin : PChar): integer; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterVerifyPin';
  function SharpTwitterGetTimeLine(var timeline : PChar; getlen : boolean): integer; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterGetTimeLine';
  function SharpTwitterUpdateStatus(status : PChar): integer; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterUpdateStatus';
  function SharpTwitterGetTokenData(token : PChar; tokenSecret : PChar; name : PChar): boolean; cdecl;
            external 'Addons\SharpTwitter.dll' name 'twitterGetTokenData';

implementation

constructor TTwitter.Create(savePath : string);
var
  Xml : TJclSimpleXml;
  token, tokenSecret, userName: string;
begin
  FSavePath := savePath;
  FAuthorized := False;
  FTimeLine := TObjectList.Create;

  token := '';
  tokenSecret := '';
  userName := '';

  // Try to see if we have a saved token
  Xml := TJclSimpleXml.Create;
  if LoadXMLFromSharedFile(Xml, FSavePath + 'TwitterToken.xml') then
  begin
    if XML.Root.Name = 'Twitter' then
    begin
      token := XML.Root.Items.Value('Token');
      tokenSecret := XML.Root.Items.Value('TokenSecret');
      userName := XML.Root.Items.Value('UserName');
    end;
  end;

  Xml.Free;

  FAuthorized := SharpTwitterAuthorize(PChar(token), PChar(tokenSecret), PChar(userName));
end;

destructor TTwitter.Destroy;
var
  n : integer;
begin
  for n := 0 to FTimeLine.Count - 1 do
    if Assigned(TTwitterFeed(FTimeLine[n]).UserImage) then
      TTwitterFeed(FTimeLine[n]).UserImage.Free;

    
  FTimeLine.Clear;
  FTimeLine.Free;
end;

function TTwitter.GetFeedCount: integer;
begin
  Result := FTimeLine.Count;
end;

function TTwitter.GetFeed(i: integer): TTwitterFeed;
begin
  if i >= FTimeLine.Count - 1 then
    i := FTimeLine.Count - 1;
    
  Result := TTwitterFeed(FTimeLine.Items[i]);
end;

procedure TTwitter.LoadImage(var vinfo : TTwitterFeed; url: string);
var
  Dir, Ext : string;

  AContentstream : TFileStream;
  idHTTP : TIdHTTP;
begin
  vinfo.UserImage := TBitmap32.Create;

  // Try to find the image first
  Dir := FSavePath + 'Images\' + IntToStr(vinfo.UserID);
  if (FileExists(Dir + '.jpg')) then
    SharpImageUtils.LoadImage(Dir + '.jpg', vinfo.UserImage)
  else if (FileExists(Dir + '.png')) then
    SharpImageUtils.LoadImage(Dir + '.png', vinfo.UserImage)
  else if (FileExists(Dir + '.gif')) then
    SharpImageUtils.LoadImage(Dir + '.gif', vinfo.UserImage)
  else if (FileExists(Dir + '.bmp')) then
    SharpImageUtils.LoadImage(Dir + '.bmp', vinfo.UserImage);

  if not vinfo.UserImage.Empty then
    exit;

  idHTTP := TidHTTP.Create(nil);
  idHTTP.ConnectTimeout := 5000;
  idHTTP.Request.Accept := 'image/jpeg,image/gif,image/png,image/bmp';
  idHTTP.HandleRedirects := True;

  // Retrieve header
  try
    idHTTP.Head(url);
  except
  end;

  if idHttp.Response.ContentType = 'image/jpeg' then
    Ext := '.jpg'
  else if idHttp.Response.ContentType = 'image/png' then
    Ext := '.png'
  else if idHttp.Response.ContentType = 'image/gif' then
    Ext := '.gif'
  else
    Ext := '.bmp';

  ForceDirectories(FSavePath + 'Images\');
  Dir := Dir + Ext;

  AContentstream := TFileStream.Create(Dir, fmCreate);
  try
    idHTTP.Get(url, AContentstream)
  except
    AContentstream.Free;
    idHTTP.Disconnect;
    idHttp.Free;

    exit;
  end;

  AContentstream.Free;
  idHTTP.Disconnect;
  idHttp.Free;

  SharpImageUtils.LoadImage(Dir, vinfo.UserImage);
end;

function TTwitter.LoadPin: integer;
begin
  Result := SharpTwitterLoadPin;
end;

function TTwitter.VerifyPin(pin: string; ShouldLoadTimeline: boolean = true): integer;
begin
  Result := SharpTwitterVerifyPin(PChar(pin));
  if Result = 0 then
    exit;

  FAuthorized := True;

  SaveToken;

  if ShouldLoadTimeline then
    LoadtimeLine;
end;

function TTwitter.UpdateStatus(newStatus : string): integer;
begin
  Result := SharpTwitterUpdateStatus(PChar(newStatus));
end;


procedure TTwitter.SaveToken;
var
  Xml : TJclSimpleXml;
  token, tokenSecret, userName: array [0..256] of Char;
begin
  SharpTwitterGetTokenData(token, tokenSecret, userName);

  // Save token info
  Xml := TJclSimpleXml.Create;
  try
    XML.Root.Items.Clear;
    XML.Root.Items.Add('Twitter');
    with Xml.Root.Items.ItemNamed['Twitter'].Items do
    begin
      Add('Token', token);
      Add('TokenSecret', tokenSecret);
      Add('UserName', userName);
    end;

    SaveXMLToSharedFile(XML, FSavePath + 'TwitterToken.xml');
  except
  end;

  Xml.Free;
end;

procedure TTwitter.LoadTimeLine;
var
  data : PChar;
  dataLen : integer;
  Xml : TJclSimpleXml;
  feed : TTwitterFeed;
  n, n2 : integer;
begin
  FTimeLine.Clear;

  dataLen := SharpTwitterGetTimeLine(data, true);

  GetMem(data, dataLen + 1);
  try
    SharpTwitterGetTimeLine(data, false);

    Xml := TJclSimpleXml.Create;
    Xml.LoadFromString(data);

    for n := 0 to XML.Root.Items.Count - 1 do
    begin
      if XML.Root.Items.Item[n].Name = 'status' then
      begin
        with XML.Root.Items.Item[n].Items do
        begin
          feed := TTwitterFeed.Create;
          feed.FeedID := IntValue('id');
          feed.Time := Value('created_at');
          feed.Text := Value('text');

          for n2 := 0 to XML.Root.Items.Item[n].Items.Count - 1 do
          begin
            if XML.Root.Items.Item[n].Items.Item[n2].Name = 'user' then
            begin
              with XML.Root.Items.Item[n].Items.Item[n2].Items do
              begin
                feed.UserID := IntValue('id');
                feed.UserName := Value('name');
                feed.UserScreenName := Value('screen_name');
                LoadImage(feed, Value('profile_image_url'));
              end;
            end;
          end;

          FTimeLine.Add(feed);
        end;
      end;
    end;
  finally
    FreeMem(data);
  end;
end;

end.
