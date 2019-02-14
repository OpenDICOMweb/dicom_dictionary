<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <book>
      <chapter>
        <table>
          <caption><xsl:value-of select="book/chapter/table/caption"/></caption>
          <tr bgcolor="#9acd32">
            <th>Title</th>
            <th>Artist</th>
          </tr>
          <tr>
            <td>
              <xsl:value-of select="catalog/cd/title"/>
            </td>
            <td>
              <xsl:value-of select="catalog/cd/artist"/>
            </td>
          </tr>
        </table>
      </chapter>
    </book>
  </xsl:template>

</xsl:stylesheet>