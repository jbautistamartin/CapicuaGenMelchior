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

require_relative '../../../melchior'

module CapicuaGen::Melchior

  # Analizador de tabla SQL segun su archivo de creacio (DLL)
  # en este caso se hace a traves de un script exportado directamente de SQL Server
  # de momento no es posible parsear un script realizado a mano, solo los exportados por
  # MS SQL Server
  class SqlTableParse

    public
    def initialize

    end

    # Parsea el string y devuelve las tablas encontradas
    def parse_string(*sql_strings)

      create_table= /(CREATE\s+TABLE[^\(]+)/mi

      tables= []

      sql_strings.each do |s|

        sql_string= s.clone

        while (sql_string.length>0) do

          # Busco la opcion de crear una tabla
          index= sql_string.index(create_table)

          # Salida
          break unless index

          # Elimino dentro lo que hay antes del CREATE TABLE
          sql_string = sql_string[index..sql_string.length]

          # Obtengo el create table completo
          table_found= find_create_table sql_string

          if table_found
            table= create_table table_found
            tables.push table
          end


          # Obtengo el resto de la cadena
          sql_string= sql_string[table_found.length..sql_string.length]
        end

        return tables


      end

    end

    # Parsea s archivos recibidos
    def parse_file(*files)

      # Resultado
      tables_string= []

      files.each do |f|
        sql_string= File.open(f).read
        tables_string << sql_string
      end

      return parse_string(*tables_string)

    end


    private


    def find_create_table sql_string
      resultado        = ''
      numero_parentesis= 1

      indexBajo= sql_string.index("(")+1
      resultado= sql_string[0..indexBajo]

      for n in indexBajo+1..sql_string.length-1 do
        caracter         = sql_string[n]
        numero_parentesis= numero_parentesis+1 if caracter=="("
        numero_parentesis= numero_parentesis-1 if caracter==")"
        resultado        = resultado+caracter
        break if numero_parentesis==0
      end

      return resultado

    end


    def create_table create_table


      #obtengo el nombre del campo
      expresion_tabla= /CREATE\s+TABLE([^\(]+)/mi
      expresion_tabla.match(create_table)
      # Nombre en crudo
      sql_name= $1
      sql_name.strip!.gsub!("\"", '')

      # Creo la tabla
      tabla= EntitySchema.new :sql_name => sql_name

      expresion_campo            = /\[?(\S+?)\]?\s+\[?(int|n?varchar|n?char|money|real|int|smallint|datetime|bit)\]?\s*(IDENTITY)?\s*(?:\(([^\)]+?)\))?\s*(NOT\s+NULL|NULL)\s*/mi
      expresion_contraint_primary= /CONSTRAINT\s+\S+\s+PRIMARY[^\(]+?\(([^\)]+)\)/mi


      expresion_contraint_primary.match(create_table)
      llaves_primarias= $1


      #obtengo todos los campos
      create_table.scan (expresion_campo) do |nombre, tipo, identity, longitud, nulo|

        nombre.gsub!('([', '')

        campo= EntityFieldSchema.new :sql_name => nombre, :sql_type => tipo

        case tipo.upcase
          when "VARCHAR", "CHAR", "NVARCHAR", "NCHAR"
            campo.size= longitud if longitud
        end

        campo.allow_null = true if /NULL/i.match(nulo)
        campo.allow_null = false if /NOT/i.match(nulo)

        #reviso a ver si es llave primaria
        campo.primary_key= true if llaves_primarias and llaves_primarias.index(campo.name)

        #Agrega información de indentidad.
        campo.identity   = true if identity

        #agrego el campo
        tabla.fields.push campo
      end


      return tabla

    end


  end

end