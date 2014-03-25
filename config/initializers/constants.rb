# General
APP_NAME = "Draftin'"
HASH_SALT = "sfpmn3iuhrf349hfn40jf3qevmlnfui34hf933onkds"
TAGLINE = "A draft simulator for Magic the Gathering."
GLOBAL_CHAT_ROOM_ID = 1

# Mixpanel
METRIC_API_KEY = "82dd3cd08638523eeb782a12a3e33a1a"
METRIC_ADMIN_API_KEY = "3687c8dd2857d8d33f27252abf9c0127"

# External Resources
DECKBREW_BASE = "https://api.deckbrew.com"
SETS_SOURCE = "#{DECKBREW_BASE}/mtg/sets"
CARDS_SOURCE = "#{DECKBREW_BASE}/mtg/cards"
PAGES_OF_CARDS = 150

# Drafts
CREATE_STAGE = 0
DRAFT_STAGE = 1
END_STAGE = 2

# Sets, Packs & Cards
IGNORED_SETS = ["DDC","DDF","EVG","DDD","DDL","DDJ","DD2","DDG","DDE","DDK","DDI","DDH","PD2","PD3","H09","PPR","HHO","DRB","V09",
                "V10","V11","V13","ARC","C13","CMA","CMD","MED","ME2","ME3","ME4","MMA","HOP","PC2","V12","VAN"]

SETS_WITH_FOILS = ["ULG","6ED","UDS","PTK","S99","MMQ","BRB","NMS","S00","PCY","INV","BTD","PLS","APC","ODY","TOR","JUD","ONS","LGN",
                   "SCG","MRD","DST","5DN","CHK","UNH","BOK","SOK","RAV","DIS","CSP","7ED","8ED","9ED","TSB","PLC","FUT","10E","LRW",
                   "MOR","SHM","EVE","ISD","DKA","ALA","CON","ARB","M10","ZEN","WWK","ROE","M11","SOM","MBS","NPH","M12","AVR","M13",
                   "RTR","GTC","DGM","M14","THS","BNG"]

# 9 commons, 3 uncommons, 1 rare or mythic, 1 flip card
PACK_LAYOUT_6 = ["ISD","DKA"]

# 8 common, 3 uncommon, 1 rare, 3 Timeshift Cards (rare or uncommon)
PACK_LAYOUT_5 = ["TSB"]

# 11 common, 3 uncommon, 1 rare
PACK_LAYOUT_4 = ["MIR","VIS","5ED","POR","WTH","TMP","STH","EXO","PO2","UGL","USG","ULG","6ED","UDS","PTK","S99","MMQ","BRB","NMS",
                 "S00","PCY","INV","BTD","PLS","APC","ODY","TOR","JUD","ONS","LGN","SCG","MRD","DST","5DN","CHK","UNH","BOK","SOK",
                 "RAV","GPT","DIS","CSP","TSP","PLC","FUT","TSP","LRW","MOR","SHM","EVE"]

# 10 common, 3 uncommon, 1 rare
PACK_LAYOUT_3 = ["4ED","ICE","ALL","CHR","7ED","8ED","9ED","10E"]

# 10 uncommon, 4 uncommon or rare
PACK_LAYOUT_2 = ["DRK","FEM","HML"]

# 10 common, 4 uncommon
PACK_LAYOUT_1 = ["LEA","LEB","2ED","ARN","ATQ","3ED","LEG"]

# Standard Pack Layout (fallback)
# 10 common, 3 uncommon, 1 rare or mythic

# rarity = ["common", "uncommon", "rare", "mythic", "special", "basic"]
# sets_with_special = {"VAN"=>"Vanguard", "PPR"=>"Promo set for Gatherer", "HOP"=>"Planechase",
# "TSB"=>"Time Spiral \"Timeshifted\"", "HHO"=>"Happy Holidays", "UNH"=>"Unhinged"}
# All VAN cards have 'special' rarity
# All TSB cards have 'special' rarity
# 1 card in 'UNH - Unhinged' has 'special' rarity
# 1 card in 'HOP - Planechase' has 'special' rarity