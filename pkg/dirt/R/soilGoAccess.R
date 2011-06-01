
# "ph1to1h2o_h", "ph1to1h2o_l"

.getSoilGoAccess <- function(mdb, depth, props) {
    props <- unique(c(props, c("hzdept_r", "hzdepb_r")))
    props <- paste("chorizon.", props, sep="")
    props <- paste(props, collapse = ", ")

    if (!require(RODBC)) { stop('RODBC package is missing') }
    con = odbcConnectAccess(mdb)
    if (con == -1) {
		if (!file.exists(mdb)) {
            stop('mdb file does not exist')
        }
        stop('cannot connect to database')
    }
    sql <- paste('SELECT mapunit.mukey, component.cokey, component.comppct_r,',  props, 'FROM (mapunit INNER JOIN component
	ON mapunit.mukey = component.mukey) INNER JOIN chorizon ON component.cokey = chorizon.cokey;')
    d <- sqlQuery(con, sql)
    close(con)
	d
}
