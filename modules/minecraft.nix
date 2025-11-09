{pkgs, ...}:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    # whitelist = {
    #   # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
    #   username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    #   username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
    # };
    serverProperties = {
      server-port = 43000;
      difficulty = 3;
      gamemode = 2;
      max-players = 5;
      motd = "Tank's Minecraft Server";
      # white-list = true;
      allow-cheats = true;
    };
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  };
}
