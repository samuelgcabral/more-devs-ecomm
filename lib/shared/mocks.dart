final List<Map<String, dynamic>> categoriesJson = [
  {
    'name': 'Frutas',
    'imageUrl':
        'https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=240&q=75',
  },
  {
    'name': 'Verduras',
    'imageUrl':
        'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=240&q=75',
  },
  {
    'name': 'Padaria',
    'imageUrl':
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=240&q=75',
  },
  {
    'name': 'Importados',
    'imageUrl':
        'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?auto=format&fit=crop&w=240&q=75',
  },
];

final List<Map<String, dynamic>> productsJson = [
  {
    'id': '46640ee7-0361-4aad-8fe3-00fd9deab31d',
    'brand': 'Natural da terra',
    'name': 'Rabanete',
    'imageUrl':
        'https://images.pexels.com/photos/26859513/pexels-photo-26859513.jpeg?auto=compress&cs=tinysrgb&w=640',
    'price': 10.99,
    'category': 'Verduras',
    'description':
        'O rabanete é uma raiz crocante e levemente picante, ideal para saladas, conservas e acompanhamentos frescos.',
  },
  {
    'id': 'dcd9a074-0360-43a8-bee8-cd2ecc80eea1',
    'brand': 'Natural da terra',
    'name': 'Cogumelo',
    'imageUrl':
        'https://images.pexels.com/photos/5950443/pexels-photo-5950443.jpeg?auto=compress&cs=tinysrgb&w=640',
    'price': 12.19,
    'category': 'Verduras',
    'description':
        'O cogumelo possui sabor delicado e textura macia, combinando com molhos, risotos, massas e diversos refogados.',
  },
  {
    'id': '191dae2f-d849-4482-b12c-d48fbbc7ae0a',
    'brand': 'Natural da terra',
    'name': 'Alface',
    'imageUrl':
        'https://images.unsplash.com/photo-1556801712-76c8eb07bbc9?auto=format&fit=crop&w=640&q=75',
    'price': 4.50,
    'category': 'Verduras',
    'description':
        'A alface é uma verdura leve, fresca e versátil, perfeita para preparar saladas, sanduíches e refeições equilibradas.',
  },
  {
    'id': '249fea87-58d0-418f-b427-f730780605b5',
    'brand': 'Akatsu',
    'name': 'Acerola',
    'imageUrl':
        'https://cdn.pixabay.com/photo/2017/08/22/19/26/acerola-2670143_640.jpg',
    'price': 7.99,
    'category': 'Frutas',
    'description':
        'A acerola é uma fruta tropical conhecida pelo seu sabor refrescante, levemente ácido e naturalmente adocicado. Rica em vitamina C e muito versátil, pode ser consumida in natura, utilizada em sucos, vitaminas, sobremesas e diversas receitas.\nIdeal para quem busca uma opção saborosa e nutritiva para o dia a dia. Produto selecionado para garantir qualidade, frescor e sabor.',
  },
  {
    'id': 'd920c0ae-3fca-4261-8b2d-35724b16ca56',
    'brand': 'Akatsu',
    'name': 'Banana',
    'imageUrl':
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=640&q=75',
    'price': 6.29,
    'category': 'Frutas',
    'description':
        'A banana é uma fruta naturalmente doce e rica em energia, ótima para lanches, vitaminas, sobremesas e receitas.',
  },
  {
    'id': 'b9350138-a6c0-422c-88ad-7257a2d53755',
    'brand': 'Akatsu',
    'name': 'Morango',
    'imageUrl':
        'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=640&q=75',
    'price': 9.90,
    'category': 'Frutas',
    'description':
        'O morango tem sabor doce e levemente ácido, sendo uma excelente opção para sobremesas, vitaminas ou consumo fresco.',
  },
  {
    'id': '95da5e5d-ea70-4cee-9b41-0c2df5329c43',
    'brand': 'Pão & Cia',
    'name': 'Pão francês',
    'imageUrl':
        'https://cdn.pixabay.com/photo/2020/06/21/15/59/french-bread-5325626_640.jpg',
    'price': 15.00,
    'category': 'Padaria',
    'description':
        'O pão francês possui casca crocante e miolo macio, ideal para acompanhar o café da manhã ou preparar sanduíches.',
  },
  {
    'id': '169b5515-38a3-4416-a2b2-736b48b64d9e',
    'brand': 'Pão & Cia',
    'name': 'Baguete',
    'imageUrl':
        'https://images.pexels.com/photos/10315700/pexels-photo-10315700.jpeg?auto=compress&cs=tinysrgb&w=640',
    'price': 8.75,
    'category': 'Padaria',
    'description':
        'A baguete é um pão de formato alongado, com casca dourada e interior macio, perfeito para entradas e sanduíches.',
  },
  {
    'id': 'd82b367c-ab36-4eda-bb01-dd112d8cb6e2',
    'brand': 'La Frontera',
    'name': 'Queijo Manchego',
    'imageUrl':
        'https://arias.es/wp-content/uploads/2022/01/casa-del-campo-semicurado-3-kilos.jpg',
    'price': 45.90,
    'category': 'Importados',
    'description':
        'O queijo Manchego é um queijo espanhol de sabor marcante e textura firme, excelente para tábuas de frios e aperitivos.',
  },
  {
    'id': '4cde902e-4d50-4876-ab8f-f6acfdd7e8f2',
    'brand': 'La Frontera',
    'name': 'Chocolate Belga',
    // Frank Wouters, CC BY 2.0: https://creativecommons.org/licenses/by/2.0/
    // https://commons.wikimedia.org/wiki/File:Belgian_chocolates.jpg
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/3/36/Belgian_chocolates.jpg',
    'price': 32.00,
    'category': 'Importados',
    'description':
        'O chocolate belga é conhecido por sua textura cremosa e sabor intenso, produzido com ingredientes de alta qualidade.',
  },
];
