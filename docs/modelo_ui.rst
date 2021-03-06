Modelo Excel para importar Unidades Informacionais
==================================================

A `importação de dados do Excel <descricao_ui.html#importacao-de-dados-em-excel>`__ implica a que
estes obedeçam a um determinado formato. Nesta página encontra-se o
formato estipulado para a tabela ``Documentos``. Cada linha desta tabela
corresponde a uma unidade informacional, que pode ser do tipo
``Documento/Processo`` ou ``Documento subordinado/Ato informacional``.
Apresentam-se de seguida as colunas da tabela, com a descrição de cada
coluna e o respetivo formato:

``Identificador *``
------------------
Identificador do documento, na tabela de importação ``Documentos``, usado exclusivamente para cruzar informação no processo de importação, não sendo guardado no GISA.

**Formato admitido / exemplos:** Preenchimento obrigatório com um valor alfanumérico, que deve ser único nesta coluna ``Identificador`` da tabela ``Documentos``.                                                                                                           

``Nível *``
------------------
Nível de descrição do documento em causa.

**Formato admitido / exemplos:** Preenchimento obrigatório, admitindo os seguintes valores: ``Documento/Processo`` ou ``Documento subordinado/Ato informacional``. Se o nível hierarquicamente superior for ``Série``, este nível pode ser do tipo ``Documento/Processo``, se for Subsérie, pode ser do tipo ``Documento/Processo``, ou então, se for ``Documento/Processo``, pode ser do tipo ``Documento subordinado/Ato informacional``.

``CodigoRef *``
------------------
Código de referência parcial relativo ao nível de descrição em causa. Considerar que o código de referência será composto pela junção dos vários códigos de referência parciais.

**Formato admitido / exemplos:** Alfanumérico obrigatório, não sendo admitidos caracteres espaço. São de evitar tanto quanto possível os caracteres / e -, pois são utilizados pelo GISA como separadores entre códigos parciais.

``Titulo *``
------------------
Título do nível de descrição.

**Formato admitido / exemplos:** Preenchimento obrigatório com um texto.

``IDNivelSuperior``  
------------------
Identificador da Unidade Informacional superior ao documento em questão (``Série``, ``Subsérie`` ou ``Documento/Processo``). Este nível superior poderá corresponder a um documento existente na mesma tabela ou então a uma descrição já existente no GISA.Para o caso do documento estar diretamente subjacente a uma Entidade Produtora do GISA, este campo terá de ficar vazio e deverá ser obrigatoriamente preenchida a coluna ``EntidadesProdutoras``.

**Formato admitido / exemplos:** Quando o documento em causa tem como superior um documento registado nesta tabela de importação, dever-se-á indicar o identificador deste documento (preenchido na coluna ``Identificador``). Quando o documento em causa tem como superior uma descrição existente no GISA, deverá ser indicado o Identificador GISA desta descrição com o seguinte formato ``gisa:12345``. O nível referido deve obedecer às seguintes regras: a) se o documento em causa for do tipo ``Documento/Processo``, o valor desta coluna deverá referir um nível que pode ser do tipo ``Subsérie`` ou ``Série``; b)se o documento em causa for do tipo ``Documento subordinado/Ato informacional``, o valor desta coluna deverá ter um nível que tem de ser do tipo ``Documento/Processo``.

``EntidadesProdutoras``  
------------------
Designação (termo autorizado) da entidade produtora à qual deverá ser diretamente associada a Unidade Informacional em causa. Para o caso do documento estar associado diretamente a uma ``Série`` ou ``Subserie``, este campo deverá ficar vazio mas terá de ser preenchida obrigatoriamente a coluna ``IDNivelSuperior``.

**Formato admitido / exemplos:** Cada entidade produtora deverá ser um termo autorizado de uma Entidade produtora já existente no GISA. Exemplos: Departamento de Urbanismo, Arquivo pessoal Emídio Biel, etc..Caso a Unidade Informacional tenha vários produtores, as designações devem ser separadas por ;.

``Autores``
------------------
Autor ou autores do documento.

**Formato admitido / exemplos:** Cada autor deverá ser um termo autorizado de uma entidade produtora já existente no GISA. Para o caso de ser mais do que um autor, estes separam-se por ;.

``DataIncerta``
------------------
Para representar datas incertas.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Antes de``; ``Depois de`` ou ``Cerca de``.

``AnoInicio`` 
------------------
Ano de inicio de produção.

**Formato admitido / exemplos:** Admite 4 dígitos, que deverão ser números (por exemplo, 2003,…) ou ? em substituição, para indicar que não se conhece o dígito (por exemplo sec XX será 19??).

``MesInicio``
------------------
Mês de inicio de produção.

**Formato admitido / exemplos:** Admite 2 dígitos correspondendo a um mês válido (por exemplo, 04,…) ou ? em substituição para indicar que não se conhece o dígito.

``DiaInicio``
------------------
Dia de inicio de produção.

**Formato admitido / exemplos:** Admite 2 dígitos correspondendo a um dia válido (por exemplo, 23,…) ou ? em substituição para indicar que não se conhece o dígito.

``AtribuidaInicio`` 
------------------
Indica se a data de início está expressa no documento ou não.

**Formato admitido / exemplos:** Admite 0 quando a data está no documento ou 1 quando a data não se encontra expressamente no documento.

``AnoFim`` 
------------------
Ano de fim de produção.

**Formato admitido / exemplos:** Admite 4 dígitos, que deverão ser números (por exemplo, 2003,…) ou ? em substituição, para indicar que não se conhece o dígito (por exemplo sec XX será 19??).

``MesFim``
------------------
Mês de fim de produção.

**Formato admitido / exemplos:** Admite 2 dígitos correspondendo a um mês válido (por exemplo, 04,…) ou ? em substituição para indicar que não se conhece o dígito.

``DiaFim``
------------------
Dia de fim de produção.

**Formato admitido / exemplos:** Admite 2 dígitos correspondendo a um dia válido (por exemplo, 23,…) ou ? em substituição para indicar que não se conhece o dígito.

``AtribuidaFim`` 
------------------
Indica se a data de fim está expressa no documento ou não.

**Formato admitido / exemplos:** Admite 0 quando a data está no documento ou 1 quando a data não se encontra expressamente no documento.

``DimensaoUnidadeInformacional``
------------------
Indicar a dimensão do nível de descrição.

**Formato admitido / exemplos:** Campo de texto.

``UnidadesFisicas``
------------------
Pode fazer referência a uma ou mais Unidades Físicas onde se pode encontrar a Unidade Informacional.

**Formato admitido / exemplos:** Deverá ser preenchido com um (ou mais) identificador alfanumérico existente na tabela ``UnidadesFísicas`` do mesmo ficheiro ou então com uma referência a uma unidade física já existente no GISA, indicando o código GISA desta unidade física com o seguinte formato gisa\_uf:PT-CMP/UF2011-123. No caso de ser mais do que uma Unidade Física, os valores separam-se por ;.

``CotaDoc``
------------------
Referência do documento na Unidade Física.

**Formato admitido / exemplos:** Campo de texto (por exemplo: Doc 23, etc.). Este campo só faz sentido ser preenchido quando a unidade informacional se encontra numa única unidade física (ou seja, o campo anterior, ``UnidadesFisicas`` ser preenchido por um único valor). Caso haja mais que uma unidade física, este campo não será considerado.

``HistoriaAdministrativa``
------------------

**Formato admitido / exemplos:** Campo de texto.

``HistoriaArquivistica`` 
------------------

**Formato admitido / exemplos:** Campo de texto.

``FonteAquisicaoOuTransferencia``
------------------

**Formato admitido / exemplos:** Campo de texto.

``TipoInformacional``
------------------
Designação da tipologia informacional da unidade de descrição.

**Formato admitido / exemplos:** Deve ser um termo autorizado de uma Tipologia informacional já existente no GISA (pe Ata).

``DiplomaLegal``
------------------
Indicar os diplomas legais pelos quais se rege o documento em questão.

**Formato admitido / exemplos:** Cada diploma legal indicado deverá existir como diploma no GISA. Para o caso de ser mais do que um diploma, estes separam-se por ;.

``Modelo`` 
------------------
Indicar os modelos pelos quais se rege a o documento em questão.

**Formato admitido / exemplos:** Cada modelo indicado deverá existir como modelo no GISA. Para o caso de ser mais do que um modelo, estes separam-se por ;.

``ConteudoInformacional``
------------------
Serve para descrever o conteúdo informacional do documento.

**Formato admitido / exemplos:** Campo de texto.

``DestinoFinal``
------------------
Permite indicar o destino final do documento.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Conservação`` ou ``Eliminação``.

``Publicacao``
------------------
Permite indicar se a descrição é pública ou não.

**Formato admitido / exemplos:** Lista de valores admitidos: ``0`` (não publicado) ou ``1`` (publicado).

``Incorporaçoes``
------------------
Permite descrever detalhes das incorporações.

**Formato admitido / exemplos:** Campo de texto.

``TradicaoDocumental`` 
------------------
Indicar um ou mais tipos de tradição documental.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Cópia``; ``Minuta``; ``Original`` ou ``Resumo``. Quando existe mais que um valor separar por ;.

``Ordenaçao`` 
------------------
Indicar um ou mais tipos de ordenação.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Aleatória``; ``Alfabética``; ``Cronológica``; ``Numérica`` ou ``Sistemática``. Quando existe mais que um valor separar por ;.

``CondicoesAcesso`` 
------------------

**Formato admitido / exemplos:** Campo de texto.

``CondicoesReproducao``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``Lingua``
------------------
Admite a designação da língua (ou línguas) usada no documento, segundo a ISO 639.

**Formato admitido / exemplos:** Lista de códigos e línguas correspondentes: abk - ``Abkhazian``; ace - ``Achinese``; ach - ``Acoli``; ada - ``Adangme``; aar - ``Afar``; afh - ``Afrihili``; afr - ``Afrikaans``; afa - ``Afro-Asiatic (Other)``; aka - ``Akan``; akk - ``Akkadian``; sqi - ``Albanian``; ale - ``Aleut``; alg - ``Algonquian languages``; tut - ``Altaic (Other)``; amh - ``Amharic``; apa - ``Apache languages``; ara - ``Arabic``; arg - ``Aragonese``; arc - ``Aramaic``; arp - ``Arapaho``; arn - ``Araucanian``; arw - ``Arawak``; hye - ``Armenian``; art - ``Artificial (Other)``; asm - ``Assamese``; ast - ``Asturian``; ath - ``Athapascan languages``; aus - ``Australian languages``; map - ``Austronesian (Other)``; ava - ``Avaric``; ave - ``Avestan``; awa - ``Awadhi``; aym - ``Aymara``; aze - ``Azerbaijani``; ast - ``Bable``; ban - ``Balinese``; bat - ``Baltic (Other)``; bal - ``Baluchi``; bam - ``Bambara``; bai - ``Bamileke languages``; bad - ``Banda``; bnt - ``Bantu (Other)``; bas - ``Basa``; bak - ``Bashkir``; eus - ``Basque``; btk - ``Batak (Indonesia)``; bej - ``Beja``; bel - ``Belarusian``; bem - ``Bemba``; ben - ``Bengali``; ber - ``Berber (Other)``; bho - ``Bhojpuri``; bih - ``Bihari``; bik - ``Bikol``; bin - ``Bini``; bis - ``Bislama``; nob - ``Bokmål, Norwegian``; bos - ``Bosnian``; bra - ``Braj``; bre - ``Breton``; bug - ``Buginese``; bul - ``Bulgarian``; bua - ``Buriat``; mya - ``Burmese``; cad - ``Caddo``; car - ``Carib``; spa - ``Castilian``; cat - ``Catalan``; cau - ``Caucasian (Other)``; ceb - ``Cebuano``; cel - ``Celtic (Other)``; cai - ``Central American Indian (Other)``; chg - ``Chagatai``; cmc - ``Chamic languages``; cha - ``Chamorro``; che - ``Chechen``; chr - ``Cherokee``; nya - ``Chewa``; chy - ``Cheyenne``; chb - ``Chibcha``; nya - ``Chichewa``; zho - ``Chinese``; chn - ``Chinook jargon``; chp - ``Chipewyan``; cho - ``Choctaw``; zha - ``Chuang``; chu - ``Church Slavic``; chu - ``Church Slavonic``; chk - ``Chuukese``; chv - ``Chuvash``; cop - ``Coptic``; cor - ``Cornish``; cos - ``Corsican``; cre - ``Cree``; mus - ``Creek``; crp - ``Creoles and pidgins(Other)``; cpe - ``Creoles and pidgins, English-based (Other)``; cpf - ``Creoles and pidgins, French-based (Other)``; cpp - C\ ``reoles and pidgins, Portuguese-based (Other)``; hrv - ``Croatian``; cus - ``Cushitic (Other)``; ces - ``Czech``; dak - ``Dakota``; dan - ``Danish``; dar - ``Dargwa``; day - ``Dayak``; del - ``Delaware``; din - ``Dinka``; div - ``Divehi``; doi - ``Dogri``; dgr - ``Dogrib``; dra - ``Dravidian (Other)``; dua - ``Duala``; nld - ``Dutch``; dum - ``Dutch, Middle (ca. 1050-1350)``; dyu - ``Dyula``; dzo - ``Dzongkha``; efi - ``Efik``; egy - ``Egyptian (Ancient)``; eka - ``Ekajuk``; elx - ``Elamite``; eng - ``English``; enm - ``English, Middle (1100-1500)``; ang - ``English, Old (ca.450-1100)``; epo - ``Esperanto``; est - ``Estonian``; ewe - ``Ewe``; ewo - ``Ewondo``; fan - ``Fang``; fat - ``Fanti``; fao - ``Faroese``; fij - ``Fijian``; fin - ``Finnish``; fiu - ``Finno-Ugrian (Other)``; fon - ``Fon``; fra - ``French``; frm - ``French, Middle (ca.1400-1600)``; fro - ``French, Old (842-ca.1400)``; fry - ``Frisian``; fur - ``Friulian``; ful - ``Fulah``; gaa - ``Ga``; gla - ``Gaelic``; glg - ``Gallegan``; lug - ``Ganda``; gay - ``Gayo``; gba - ``Gbaya``; gez - ``Geez``; kat - ``Georgian``; deu - ``German``; nds - ``German, Lowgmh - German, Middle High (ca.1050-1500)``; goh - ``German, Old High (ca.750-1050)``; gem - ``Germanic (Other)``; kik - ``Gikuyu``; gil - ``Gilbertese``; gon - ``Gondi``; gor - ``Gorontalo``; got - ``Gothic``; grb - ``Grebo``; grc - ``Greek, Ancient (to 1453)``; ell - ``Greek, Modern (1453-)``; grn - ``Guarani``; guj - ``Gujarati``; gwi - ``Gwich´in``; hai - ``Haida``; hau - ``Hausa``; haw - ``Hawaiian``; heb - ``Hebrew``; her - ``Herero``; hil - ``Hiligaynon``; him - ``Himachali``; hin - ``Hindi``; hmo - ``Hiri Motu``; hit - ``Hittite``; hmn - ``Hmong``; hun - ``Hungarian``; hup - ``Hupa``; iba - ``Iban``; isl - ``Icelandic``; ido - ``Ido``; ibo - ``Igbo``; ijo - ``Ijo``; ilo - ``Iloko``; smn - ``Inari Sami``; inc - ``Indic (Other)``; ine - ``Indo-European (Other)``; ind - ``Indonesian``; inh - ``Ingush``; ile - ``Interlingue``; iku - ``Inuktitut``; ipk - ``Inupiaq``; ira - ``Iranian (Other)``; gle - ``Irish``; mga - ``Irish, Middle (900-1200)``; sga - ``Irish, Old (to 900)``; iro - ``Iroquoian languages``; ita - ``Italian``; jpn - ``Japanese``; jav - ``Javanese``; jrb - ``Judeo-Arabic``; jpr - ``Judeo-Persian``; kbd - ``Kabardian``; kab - ``Kabyle``; kac - ``Kachin``; kal - ``Kalaallisut``; kam - ``Kamba``; kan - ``Kannada``; kau - ``Kanuri``; kaa - ``Kara-Kalpak``; kar - ``Karen``; kas - ``Kashmiri``; kaw - ``Kawi``; kaz - ``Kazakh``; kha - ``Khasi``; khm - ``Khmer``; khi - ``Khoisan (Other)``; kho - ``Khotanese``; kik - ``Kikuyu``; kmb - ``Kimbundu``; kin - ``Kinyarwanda``; kir - ``Kirghiz``; kom - ``Komi``; kon - ``Kongo``; kok - ``Konkani``; kor - ``Korean``; kos - ``Kosraean``; kpe - ``Kpelle``; kro - ``Kru``; kua - ``Kuanyama``; kum - ``Kumyk``; kur - ``Kurdish``; kru - ``Kurukh``; kut - ``Kutenai``; kua - ``Kwanyama``; lad - ``Ladino``; lah - ``Lahnda``; lam - ``Lamba``; lao - ``Lao``; lat - ``Latin``; lav - ``Latvian``; ltz - ``Letzeburgesch``; lez - ``Lezghian``; lim - ``Limburgan``; lim - ``Limburger``; lim - ``limburgish``; lin - ``Lingala``; lit - ``Lithuanian``; nds - ``Low German``; nds - ``Low Saxon``; loz - ``Lozi``; lub - ``Luba-Katanga``; lua - ``Luba-Lulua``; lui - ``Luiseno``; smj - ``Lule Sami``; lun - ``Lunda``; luo - ``Luo (Kenya and Tanzania)``; ltz - ``Luxembourgish``; lus - ``Lushai``; mkd - ``Macedonian``; mad - ``Madurese``; mag - ``Magahi``; mai - ``Maithili``; mak - ``Makasar``; mlg - ``Malagasy``; msa - ``Malay``; mal - ``Malayalam``; mlt - ``Maltese``; mnc - ``Manchu``; mdr - ``Mandar``; man - ``Mandingo``; mni - ``Manipuri``; mno - ``Manobo languages``; glv - ``Manx``; mri - ``Maori``; mar - ``Marathi``; chm - ``Mari``; mah - ``Marshallese``; mwr - ``Marwari``; mas - ``Masai``; myn - ``Mayan languages``; men - ``Mende``; mic - ``Micmac``; min - ``Minangkabau``; mis - ``Miscellaneous languages``; moh - ``Mohawk``; mol - ``Moldavian``; mkh - ``Mon-Khmer (Other)``; lol - ``Mongo``; mon - ``Mongolian``; mos - ``Mossi``; mul - ``Multiple languages``; mun - ``Munda languages``; nah - ``Nahuatl``; nau - ``Nauru``; nav - ``Navaho``; nav - ``Navajo``; nde - ``Ndebele, North``; nbl - ``Ndebele, South``; ndo - ``Ndonga``; nap - ``Neapolitan``; nep - ``Nepali``; new - ``Newari``; nia - ``Nias``; nic - ``Niger-Kordofanian (Other)``; ssa - ``Nilo-Saharan (Other)``; niu - ``Niuean``; non - ``Norse, Old``; nai - ``North American Indian (Other)``; sme - ``Northern Sami``; nde - ``North Ndebele``; nor - ``Norwegian``; nob - ``Norwegian Bokmål``; nno - ``Norwegian Nynorsk``; nub - ``Nubian languages``; nym - ``Nyamwezi``; nya - ``Nyanja``; nyn - ``Nyankole``; nno - ``Nynorsk, Norwegian``; nyo - ``Nyoro``; nzi - ``Nzima``; oci - ``Occitan (post 1500)``; oji - ``Ojibwa``; chu - ``Old Bulgarian``; chu - ``Old Church Slavonic``; chu - ``Old Slavonic``; ori - ``Oriya``; orm - ``Oromo``; osa - ``Osage``; oss - ``Ossetian``; oss - ``Ossetic``; oto - ``Otomian languages``; pal - ``Pahlavi``; pau - ``Palauan``; pli - ``Pali``; pam - ``Pampanga``; pag - ``Pangasinan``; pan - ``Panjabi``; pap - ``Papiamento``; paa - ``Papuan (Other)``; fas - ``Persian``; peo - ``Persian, Old (ca.600-400)``; phi - ``Philippine (Other)``; phn - ``Phoenician``; pon - ``Pohnpeian``; pol - ``Polish``; por - ``Portuguese``; pra - ``Prakrit languages``; oci - ``Provençal``; pro - ``Provençal, Old (to 1500)``; pus - ``Pushto``; que - ``Quechua``; roh - ``Raeto-Romance``; raj - ``Rajasthani``; rap - ``Rapanui``; rar - ``Rarotongan``; qtz - ``Reserved for local user``; roa - ``Romance (Other)``; ron - ``Romanian``; rom - ``Romany``; run - ``Rundi``; rus - ``Russian``; sal - ``Salishan languages``; sam - ``Samaritan Aramaic``; smi - ``Sami languages (Other)``; smo - ``Samoan``; sad - ``Sandawe``; sag - ``Sango``; san - ``Sanskrit``; sat - ``Santali``; srd - ``Sardinian``; sas - ``Sasak``; nds - ``Saxon, Low``; sco - ``Scots``; gla - ``Scottish Gaelic``; sel - ``Selkup``; sem - ``Semitic (Other)``; srp - ``Serbian``; srr - ``Serer``; shn - ``Shan``; sna - ``Shona``; iii - ``Sichuan Yi``; sid - ``Sidamo``; sgn - ``Sign languages``; bla - ``Siksika``; snd - ``Sindhi``; sin - ``Sinhalese``; sit - ``Sino-Tibetan (Other)``; sio - ``Siouan languages``; sms - ``Skolt Sami``; den - ``Slave (Athapascan)``; sla - ``Slavic (Other)``; slk - ``Slovak``; slv - ``Slovenian``; sog - ``Sogdian``; som - ``Somali``; son - ``Songhai``; snk - ``Soninke``; wen - ``Sorbian languages``; nso - ``Sotho, Northern``; sot - ``Sotho, Southern``; sai - ``South American Indian (Other)``; sma - ``Southern Sami``; nbl - ``South Ndebele``; spa - ``Spanish``; suk - ``Sukuma``; sux - ``Sumerian``; sun - ``Sundanese``; sus - ``Susu``; swa - ``Swahili``; ssw - ``Swati``; swe - ``Swedish``; syr - ``Syriac``; tgl - ``Tagalog``; tah - ``Tahitian``; tai - ``Tai (Other)``; tgk - ``Tajik``; tmh - ``Tamashek``; tam - ``Tamil``; tat - ``Tatar``; tel - ``Telugu``; ter - ``Tereno``; tet - ``Tetum``; tha - ``Thai``; bod - ``Tibetan``; tig - ``Tigre``; tir - ``Tigrinya``; tem - ``Timne``; tiv - ``Tiv``; tli - ``Tlingit``; tpi - ``Tok Pisin``; tkl - ``Tokelau``; tog - ``Tonga (Nyasa)``; ton - ``Tonga (Tonga Islands)``; tsi - ``Tsimshian``; tso - ``Tsonga``; tsn - ``Tswana``; tum - ``Tumbuka``; tup - ``Tupi languages``; tur - ``Turkish``; ota - ``Turkish, Ottoman (1500-1928)``; tuk - ``Turkmen``; tvl - ``Tuvalu``; tyv - ``Tuvinian``; twi - ``Twi``; uga - ``Ugaritic``; uig - ``Uighur``; ukr - ``Ukrainian``; umb - ``Umbundu``; und - ``Undetermined``; urd - ``Urdu``; uzb - ``Uzbek``; vai - ``Vai``; ven - ``Venda``; vie - ``Vietnamese``; vol - ``Volapük``; vot - ``Votic``; wak - ``Wakashan languages``; wal - ``Walamo``; wln - ``Walloon``; war - ``Waray``; was - ``Washo``; cym - ``Welsh``; wol - ``Wolof``; xho - ``Xhosa``; sah - ``Yakut``; yao - ``Yao``; yap - ``Yapese``; yid - ``Yiddish``; yor - ``Yoruba``; ypk - ``Yupik languages``; znd - ``Zande``; zap - ``Zapotec``; zen - ``Zenaga``; zha - ``Zhuang``; zul - ``Zulu``; zun – ``Zuni``. Quando existe mais que um valor separar por ;.

``Alfabeto``    
------------------
Admite a designação do alfabeto (ou alfabetos) usado no documento, segundo a ISO 15924.

**Formato admitido / exemplos:** Lista de códigos e correspondentes alfabetos: 919 - ``::CodeAlpha Qt, Qat:: has no Name in ISO15924930 - (alias for Han + Hiragana + Katakana)``; 931 - ``(alias for Hangul + Han)``; 412 - ``(alias for Hiragana + Katakana)``; 160 - ``Arabic``; 130 - ``Aramaic``; 230 - ``Armenian``; 151 - ``Avestan``; 365 - ``Batak``; 325 - ``Bengali``; 550 - ``Blissymbols``; 285 - ``Bopomofo``; 300 - ``Brahmi (Ashoka)``; 570 - ``Braille``; 367 - ``Buginese (Makassar)``; 372 - ``Buhid``; 350 - ``Burmese``; 358 - ``Cham``; 445 - ``Cherokee syllabary``; 291 - ``Cirth``; 999 - ``Code for uncoded script``; 998 - ``Code for undetermined script``; 997 - ``Code for unwritten languages``; 205 - ``Coptic``; 105 - ``Cuneiform, Old Persian``; 0 - ``Cuneiform, Sumero-Akkadian``; 106 - ``Cuneiform, Ugaritic``; 403 - ``Cypriote syllabary``; 402 - ``Cypro-Minoan``; 220 - ``Cyrillic``; 250 - ``Deseret (Mormon)``; 315 - ``Devanagari (Nagari)``; 70 - ``Egyptian demotic``; 60 - ``Egyptian hieratic``; 50 - ``Egyptian hieroglyphs``; 430 - ``Ethiopic``; 210 - ``Etruscan and Oscan``; 241 - ``Georgian (Mxedruli)``; 240 - ``Georgian (Xucuri)``; 225 - ``Glagolitic``; 206 - ``Gothic``; 200 - ``Greek``; 320 - ``Gujarati``; 310 - ``Gurmukhi``; 500 - ``Han ideographs``; 420 - ``Hangul``; 371 - ``Hanunóo``; 125 - ``Hebrew``; 410 - ``Hiragana``; 610 - ``Indus Valley``; 360 - ``Javanese``; 345 - ``Kannada``; 357 - ``Karenni (Kayah Li)``; 411 - ``Katakana``; 305 - ``Kharoshthi``; 354 - ``Khmer``; 295 - ``Klingon pIQaD``; 175 - ``Kök Turki runic``; 356 - ``Lao``; 217 - ``Latin``; 215 - ``Latin (Fraktur variant)``; 216 - ``Latin (Gaelic variant)``; 335 - ``Lepcha (Róng)``; 400 - ``Linear A``; 401 - ``Linear B``; 347 - ``Malayalam``; 140 - ``Mandaean``; 90 - ``Mayan hieroglyphs``; 100 - ``Meroitic``; 145 - ``Mongolian``; 212 - ``Ogham``; 221 - ``Old Church Slavonic``; 176 - ``Old Hungarian runic``; 227 - ``Old Permic``; 327 - ``Oriya``; 260 - ``Osmanya``; 450 - ``Pahawh Hmong``; 150 - ``Pahlavi``; 600 - ``Phaistos Disk``; 115 - ``Phoenician``; 282 - ``Pollard Phonetic``; 900 - ``Reserved for private use``; 620 - ``Rongo-rongo``; 211 - ``Runic (Germanic)``; 281 - ``Shavian (Shaw)``; 348 - ``Sinhala``; 110 - ``South Arabian``; 135 - ``Syriac``; 370 - ``Tagalog``; 373 - ``Tagbanwa``; 346 - ``Tamil``; 340 - ``Telugu``; 290 - ``Tengwar``; 170 - ``Thaana``; 352 - ``Thai``; 330 - ``Tibetan``; 120 - ``Tifinagh``; 440 - ``Unified Canadian Aboriginal Syllabics``; 470 - ``Vai``; 280 - ``Visible Speech``; 460 – ``Yi``. Quando existe mais que um valor separar por ;.

``FormaSuporte``  
------------------
Preencher uma ou mais formas de suporte usadas.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Folhas``; ``Caderneta``; ``Caderno``; ``Livro``; ``Fichas``; ``Caixa``; ``Maço``; ``Pasta``; ``Envelope``; ``Rolo``; ``Bobina``; ``Cassete``; ``Disco``; ``Disquete`` ou ``Outra``. Quando existe mais que um valor separar por ;.

``MaterialSuporte``  
------------------
Preencher um ou mais materiais de suporte usados.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Papel``; ``Pergaminho``; ``Película``; ``Vidro``; ``Metal``; ``Tecido``; ``Vinil``; ``PVC``; ``Tela``; ``Pele`` ou ``Outro``. Quando existe mais que um valor separar por ;.

``TecnicaRegisto``  
------------------
Preencher uma ou mais técnicas de registo usadas.

**Formato admitido / exemplos:** Lista de valores admitidos: ``Manuscrito``; ``Impresso``; ``Gravura``; ``Fotografia``; ``Microfilme``; ``Filme``; ``Áudio``; ``Audiovisual``; ``Magnético``; ``Óptico``; ``Multimédia`` ou ``Outra``. Quando existe mais que um valor separar por ;.

``EstadoConservacao``  
------------------

**Formato admitido / exemplos:** Lista de valores admitidos: ``Bom``; ``Mau`` ou ``Razoável``.

``InstrumentosPesquisa``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``ExistenciaOriginais``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``ExistenciaCopias``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``UnidadesDescricaoRelacionadas``   
------------------

**Formato admitido / exemplos:** Campo de texto.

``Notas``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``NotaArquivista``  
------------------

**Formato admitido / exemplos:** Campo de texto.

``Regras``  
------------------
Regras ou convenções.

**Formato admitido / exemplos:** Campo de texto.

``AutorDescricao``  
------------------
Nome do autor da descrição.

**Formato admitido / exemplos:** O nome deve existir no GISA como utilizador marcado como autor.

``DataAutoria``  
------------------
Data de autoria do documento. Quando não indicada é assumida a data de registo.

**Formato admitido / exemplos:** A data deve seguir o seguinte formato: ``AAAAMMDD`` (por exemplo: 20110602).

``Onomasticos``  
------------------
Permite a associação de termos de indexação do tipo ``Onomástico`` ao documento. 

**Formato admitido / exemplos:** Admite um termo autorizado (ou uma lista de termos separados por ;), já registado no GISA como onomástico.

``Ideograficos``  
------------------
Permite a associação de termos de indexação do tipo ``Ideográfico`` ao documento.

**Formato admitido / exemplos:** Admite um termo autorizado (ou uma lista de termos separados por ;), registado no GISA como ideográfico.

``Geograficos``  
------------------
Permite a associação de termos de indexação do tipo ``Nome geográfico/Topónimo citadino`` ao documento.

**Formato admitido / exemplos:** Admite um termo autorizado (ou uma lista de termos separados por ;), registado no GISA como geográfico.
