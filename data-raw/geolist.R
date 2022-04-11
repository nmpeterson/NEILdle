#install.packages(c("tidyverse", "sf"))
#devtools::install_github('cmap-repos/cmapgeo')
library(tidyverse)
library(sf)
library(cmapgeo)


## Coerce desired geographies (municipalities, CCAs and/or counties) into a unified schema.
## (Note that each will need to have a unique name, or else app.R could have problems.
## For example, McHenry (muni) and McHenry (county) need to be differentiated, as do
## Riverdale (muni) and Riverdale (CCA).)
munis <- municipality_sf %>%
  mutate(geo_type = "municipality",
         geo_name = str_replace_all(municipality, "['.]", ""),
         geo_name_std = tolower(geo_name)) %>%
  select(geo_type, geo_name, geo_name_std)

# counties <- county_sf %>%
#   filter(cmap) %>%
#   mutate(geo_type = "county",
#          geo_name = paste(county, "County"),
#          geo_name_std = tolower(geo_name)) %>%
#   select(geo_type, geo_name, geo_name_std)

# ccas <- cca_sf %>%
#   filter(cca_name != "Riverdale") %>%  # Avoid confusion with the muni of the same name
#   mutate(geo_type = "CCA",
#          geo_name = str_replace_all(cca_name, "['.]", ""),
#          geo_name_std = tolower(geo_name)) %>%
#   select(geo_type, geo_name, geo_name_std)

## Combine any geographies into a single table and create centroid points
# all_geos <- bind_rows(counties, munis, ccas) %>%
all_geos <- munis %>%
  mutate(centroid = st_centroid(.$geometry))


## Pre-calculate distances between all geographies
geo_distances <- st_distance(all_geos, all_geos)


## Save datasets for importing in app.R
save(all_geos, file="data/all_geos.rda")
save(geo_distances, file="data/geo_distances.rda")
