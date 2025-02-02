-- br230
import("publish")

local description = [[
	This application presents data collection methodology and initial results description for the fieldwork carried out from September 06th to 26th, 2013, at terra firme (mainland) communities in the Sustainable Forest District of BR-163, southwestem Pará.
	This work complements and partially reproduces field surveys conducted at riverine communities of the Tapajós and Arapiuns Rivers in 2009 and 2012, respectively. The main objective was to characterize the
	organization and interdependence between settlements concerning to:infrastructure, health and education services,
	land use, ecosystem services provision and perception of welfare. This fieldwork was partially funded by projects UrbisAmazônia (ITV-DS Instituto Tecnológico Vale - Desenvolvimento Sustentável process #3.611.000.00/11) and LUA-IAM (FAPESP process #08/58112-0).<br>
	Source: <a href = "http://mtc-m21b.sid.inpe.br/rep/8JMKD3MGP3W34P/3PAAHQ5" target="_blank">Dal'Asta et. al (2015) As comunidades de terra firme do Sudoeste do Pará: população, infraestrutura, serviços, uso da terra e concetividades. Expedição de campo 2013.
	Relatório Técnico de Atividade de Campo</a>.
]]

Application{
    key = "AIzaSyA1coAth-Bo7m99rnxOm2oOBB88AmaSbOk",
	project = "BR230.tview",
	description = description,
	base = "roadmap",
	template = {navbar = "darkblue", title = "white"},
    display = false,
--[[
     trajectory = View{
		description = "Route on the BR230.",
		width = 3,
		border = "blue",
		icon = {
			path = "M150 0 L75 200 L225 200 Z",
			transparency = 0.2,
			time = 20
		}
	},
    --]]
	villages = View{
		description = "Settlements corresponded to agrovilas, villages and communities.",
		select = {"CMM", "TIPO"},
		icon = {"home", "forest"},
		label = {"PA", "cmm"},
		report = function(cell)
			local mreport = Report{

				title = cell.Nome,
				author = "Dal'Asta et. al (2015)"
			}

			local age = math.ceil(130 * cell.IDDCM / 0.77)
			local pop = math.ceil(350 * cell.NPES / 0.8)

			local text = "The community "..cell.Nome.." was founded "..age.." years ago and has around "..pop.." inhabitants."

			if cell.PA == 1 then
				text = text.." It belongs to a Settlement Project."
			else
				text = text.." It belongs to spontaneous community."
			end

			local health, water
			if cell.PSAU > 0 then health = "has" else health = "hasn't" end
			if cell.AGUA > 0 then water  = "has" else water  = "hasn't" end

			text = text..string.format(" The community %s health center and %s access to water.", health, water)

			if cell.BFAM == 0 then
				text = text.." It has no Bolsa Familia."
			elseif cell.BFAM <= 0.3 then
				text = text.." Few of its inhabitants have Bolsa Familia."
			elseif cell.BFAM <= 0.6 then
				text = text.." Many of its inhabitants have Bolsa Familia."
			elseif cell.BFAM <= 0.8 then
				text = text.." Most of its inhabitants have Bolsa Familia."
			else
				text = text.." All inhabitants have Bolsa Familia."
			end

			mreport:addText(text)

			local infrastructure = {}

			if cell.IGREJAS > 0 then
				if cell.IGREJAS > 0.6 then
					table.insert(infrastructure, "churches")
				else
					table.insert(infrastructure, "church")
				end
			end

			if cell.CFUT    == 1 then table.insert(infrastructure, "soccer field")     end
			if cell.ORELHAO == 1 then table.insert(infrastructure, "public telephone") end
			if cell.ENERGIA  > 0 then table.insert(infrastructure, "oil generator")    end

			local school = {}
			if cell.ENSINF > 0   then table.insert(school, "Early Childhood Education")     end
			if cell.ENSFUND2 > 0 then table.insert(school, "Elementary School")             end
			if cell.EJA > 0      then table.insert(school, "Education of Young and Adults") end

			if #school > 0 then
				table.insert(infrastructure, "school")
			end

			if #infrastructure > 0 then
				text = string.format(cell.Nome.." has the following infrastructure: %s.", table.concat(infrastructure, ", "))

				if #school > 0 then
					text = text..string.format(" The school offers %s.", table.concat(school, ", "))
				end

				mreport:addText(text)
			end

			local production = {}

			if cell.ACAI     == 1 then table.insert(production, "acai")     end
			if cell.GADO     == 1 then table.insert(production, "cattle")   end
			if cell.CASTANHA == 1 then table.insert(production, "chestnut") end
			if cell.FRUTAS   == 1 then table.insert(production, "fruits")   end
			if cell.MAND     == 1 then table.insert(production, "mandioc")  end
			if cell.ARROZ    == 1 then table.insert(production, "rice")     end

			if #production > 0 then
				mreport:addText(string.format("The community produces the following commodities: %s.", table.concat(production, ", ")))
			end

            mreport:addImage("photos/"..cell.Nome..".jpg")
			return mreport
		end
	}
}
