=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martin, el 6 de enero
del 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso el
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

=begin
Melchior es un conjunto de generadores de caracteristicas de ejemplo pertenecientes a CapicuaGen
que se ocupa entre otras cosas de definir las clase para manejar entidades.
=end

require_relative 'version'
require 'CapicuaGen/capicua_gen'
require_relative 'DataAccess/EntitySqlDataAccess/Source/entity_field_schema'
require_relative 'DataAccess/EntitySqlDataAccess/Source/entity_schema'
require_relative 'DataAccess/EntitySqlDataAccess/Source/entity_sql_data_access_feature'
require_relative 'DataAccess/EntitySqlDataAccess/Source/sql_table_parser'
