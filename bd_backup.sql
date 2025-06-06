PGDMP  #                     }            db_productos    17.4    17.4 =               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            	           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            
           1262    65539    db_productos    DATABASE     r   CREATE DATABASE db_productos WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-ES';
    DROP DATABASE db_productos;
                     postgres    false                        2615    65540 	   auditoria    SCHEMA        CREATE SCHEMA auditoria;
    DROP SCHEMA auditoria;
                     postgres    false            �            1255    65541    fn_log_audit()    FUNCTION     ^	  CREATE FUNCTION public.fn_log_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_valor_anterior JSONB;
    v_valor_nuevo JSONB;
    v_usuario TEXT;
BEGIN
    -- Obtener el usuario desde la variable de sesión
    v_usuario := COALESCE(current_setting('custom.app_usuario', true), 'Desconocido');

    IF (TG_OP = 'DELETE') THEN
        SELECT jsonb_build_object(
            'id_pr', OLD.id_pr,
            'id_cat', OLD.id_cat,
            'nombre_pr', OLD.nombre_pr,
            'cantidad_pr', OLD.cantidad_pr,
            'precio_pr', OLD.precio_pr
        ) INTO v_valor_anterior;

        INSERT INTO "auditoria".tb_auditoria (
            tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud, esquema_aud
        ) VALUES (
            TG_TABLE_NAME, 'D', v_valor_anterior::TEXT, NULL, NOW(), v_usuario, TG_TABLE_SCHEMA
        );
        RETURN OLD;

    ELSIF (TG_OP = 'UPDATE') THEN
        SELECT jsonb_build_object(
            'id_pr', OLD.id_pr,
            'id_cat', OLD.id_cat,
            'nombre_pr', OLD.nombre_pr,
            'cantidad_pr', OLD.cantidad_pr,
            'precio_pr', OLD.precio_pr
        ) INTO v_valor_anterior;

        SELECT jsonb_build_object(
            'id_pr', NEW.id_pr,
            'id_cat', NEW.id_cat,
            'nombre_pr', NEW.nombre_pr,
            'cantidad_pr', NEW.cantidad_pr,
            'precio_pr', NEW.precio_pr
        ) INTO v_valor_nuevo;

        INSERT INTO "auditoria".tb_auditoria (
            tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud, esquema_aud
        ) VALUES (
            TG_TABLE_NAME, 'U', v_valor_anterior::TEXT, v_valor_nuevo::TEXT, NOW(), v_usuario, TG_TABLE_SCHEMA
        );
        RETURN NEW;

    ELSIF (TG_OP = 'INSERT') THEN
        SELECT jsonb_build_object(
            'id_pr', NEW.id_pr,
            'id_cat', NEW.id_cat,
            'nombre_pr', NEW.nombre_pr,
            'cantidad_pr', NEW.cantidad_pr,
            'precio_pr', NEW.precio_pr
        ) INTO v_valor_nuevo;

        INSERT INTO "auditoria".tb_auditoria (
            tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud, esquema_aud
        ) VALUES (
            TG_TABLE_NAME, 'I', NULL, v_valor_nuevo::TEXT, NOW(), v_usuario, TG_TABLE_SCHEMA
        );
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$;
 %   DROP FUNCTION public.fn_log_audit();
       public               postgres    false            �            1259    65542    tb_auditoria    TABLE       CREATE TABLE auditoria.tb_auditoria (
    id_aud integer NOT NULL,
    tabla_aud text,
    operacion_aud text,
    valoranterior_aud text,
    valornuevo_aud text,
    fecha_aud date,
    usuario_aud text,
    esquema_aud text,
    activar_aud boolean,
    trigger_aud boolean
);
 #   DROP TABLE auditoria.tb_auditoria;
    	   auditoria         heap r       postgres    false    6            �            1259    65547    tb_auditoria_id_aud_seq    SEQUENCE     �   CREATE SEQUENCE auditoria.tb_auditoria_id_aud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE auditoria.tb_auditoria_id_aud_seq;
    	   auditoria               postgres    false    218    6                       0    0    tb_auditoria_id_aud_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE auditoria.tb_auditoria_id_aud_seq OWNED BY auditoria.tb_auditoria.id_aud;
       	   auditoria               postgres    false    219            �            1259    65646 
   tb_carrito    TABLE       CREATE TABLE public.tb_carrito (
    id_carrito integer NOT NULL,
    id_usuario integer NOT NULL,
    nombre_pr text NOT NULL,
    cantidad integer DEFAULT 1,
    id_estado integer DEFAULT 1,
    fecha_agregado timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.tb_carrito;
       public         heap r       postgres    false            �            1259    65645    tb_carrito_id_carrito_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_carrito_id_carrito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.tb_carrito_id_carrito_seq;
       public               postgres    false    234                       0    0    tb_carrito_id_carrito_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.tb_carrito_id_carrito_seq OWNED BY public.tb_carrito.id_carrito;
          public               postgres    false    233            �            1259    65548    tb_categoria    TABLE     e   CREATE TABLE public.tb_categoria (
    id_cat integer NOT NULL,
    descripcion_cat text NOT NULL
);
     DROP TABLE public.tb_categoria;
       public         heap r       postgres    false            �            1259    65553    tb_categoria_id_cat_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_categoria_id_cat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tb_categoria_id_cat_seq;
       public               postgres    false    220                       0    0    tb_categoria_id_cat_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tb_categoria_id_cat_seq OWNED BY public.tb_categoria.id_cat;
          public               postgres    false    221            �            1259    65554    tb_estadocivil    TABLE     ^   CREATE TABLE public.tb_estadocivil (
    id_est integer NOT NULL,
    descripcion_est text
);
 "   DROP TABLE public.tb_estadocivil;
       public         heap r       postgres    false            �            1259    65559    tb_estadocivil_id_est_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_estadocivil_id_est_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.tb_estadocivil_id_est_seq;
       public               postgres    false    222                       0    0    tb_estadocivil_id_est_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.tb_estadocivil_id_est_seq OWNED BY public.tb_estadocivil.id_est;
          public               postgres    false    223            �            1259    65560 	   tb_pagina    TABLE     l   CREATE TABLE public.tb_pagina (
    id_pag integer NOT NULL,
    descripcion_pag text,
    path_pag text
);
    DROP TABLE public.tb_pagina;
       public         heap r       postgres    false            �            1259    65565    tb_parametros    TABLE     q   CREATE TABLE public.tb_parametros (
    id_par integer NOT NULL,
    descripcion_par text,
    valor_par text
);
 !   DROP TABLE public.tb_parametros;
       public         heap r       postgres    false            �            1259    65570 	   tb_perfil    TABLE     Y   CREATE TABLE public.tb_perfil (
    id_per integer NOT NULL,
    descripcion_per text
);
    DROP TABLE public.tb_perfil;
       public         heap r       postgres    false            �            1259    65575    tb_perfilpagina    TABLE     p   CREATE TABLE public.tb_perfilpagina (
    id_perpag integer NOT NULL,
    id_per integer,
    id_pag integer
);
 #   DROP TABLE public.tb_perfilpagina;
       public         heap r       postgres    false            �            1259    65578    tb_perfilpagina_id_perpag_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_perfilpagina_id_perpag_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tb_perfilpagina_id_perpag_seq;
       public               postgres    false    227                       0    0    tb_perfilpagina_id_perpag_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.tb_perfilpagina_id_perpag_seq OWNED BY public.tb_perfilpagina.id_perpag;
          public               postgres    false    228            �            1259    65579    tb_producto    TABLE     �   CREATE TABLE public.tb_producto (
    id_pr integer NOT NULL,
    id_cat integer,
    nombre_pr text NOT NULL,
    cantidad_pr integer,
    precio_pr double precision,
    foto_pr text
);
    DROP TABLE public.tb_producto;
       public         heap r       postgres    false            �            1259    65584    tb_producto_id_pr_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_producto_id_pr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.tb_producto_id_pr_seq;
       public               postgres    false    229                       0    0    tb_producto_id_pr_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.tb_producto_id_pr_seq OWNED BY public.tb_producto.id_pr;
          public               postgres    false    230            �            1259    65585 
   tb_usuario    TABLE     �   CREATE TABLE public.tb_usuario (
    id_us integer NOT NULL,
    id_per integer,
    id_est integer,
    nombre_us text,
    cedula_us text,
    correo_us text,
    clave_us text,
    estado integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.tb_usuario;
       public         heap r       postgres    false            �            1259    65590    tb_usuario_id_us_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_usuario_id_us_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tb_usuario_id_us_seq;
       public               postgres    false    231                       0    0    tb_usuario_id_us_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tb_usuario_id_us_seq OWNED BY public.tb_usuario.id_us;
          public               postgres    false    232            M           2604    65591    tb_auditoria id_aud    DEFAULT     �   ALTER TABLE ONLY auditoria.tb_auditoria ALTER COLUMN id_aud SET DEFAULT nextval('auditoria.tb_auditoria_id_aud_seq'::regclass);
 E   ALTER TABLE auditoria.tb_auditoria ALTER COLUMN id_aud DROP DEFAULT;
    	   auditoria               postgres    false    219    218            T           2604    65649    tb_carrito id_carrito    DEFAULT     ~   ALTER TABLE ONLY public.tb_carrito ALTER COLUMN id_carrito SET DEFAULT nextval('public.tb_carrito_id_carrito_seq'::regclass);
 D   ALTER TABLE public.tb_carrito ALTER COLUMN id_carrito DROP DEFAULT;
       public               postgres    false    234    233    234            N           2604    65592    tb_categoria id_cat    DEFAULT     z   ALTER TABLE ONLY public.tb_categoria ALTER COLUMN id_cat SET DEFAULT nextval('public.tb_categoria_id_cat_seq'::regclass);
 B   ALTER TABLE public.tb_categoria ALTER COLUMN id_cat DROP DEFAULT;
       public               postgres    false    221    220            O           2604    65593    tb_estadocivil id_est    DEFAULT     ~   ALTER TABLE ONLY public.tb_estadocivil ALTER COLUMN id_est SET DEFAULT nextval('public.tb_estadocivil_id_est_seq'::regclass);
 D   ALTER TABLE public.tb_estadocivil ALTER COLUMN id_est DROP DEFAULT;
       public               postgres    false    223    222            P           2604    65594    tb_perfilpagina id_perpag    DEFAULT     �   ALTER TABLE ONLY public.tb_perfilpagina ALTER COLUMN id_perpag SET DEFAULT nextval('public.tb_perfilpagina_id_perpag_seq'::regclass);
 H   ALTER TABLE public.tb_perfilpagina ALTER COLUMN id_perpag DROP DEFAULT;
       public               postgres    false    228    227            Q           2604    65595    tb_producto id_pr    DEFAULT     v   ALTER TABLE ONLY public.tb_producto ALTER COLUMN id_pr SET DEFAULT nextval('public.tb_producto_id_pr_seq'::regclass);
 @   ALTER TABLE public.tb_producto ALTER COLUMN id_pr DROP DEFAULT;
       public               postgres    false    230    229            R           2604    65596    tb_usuario id_us    DEFAULT     t   ALTER TABLE ONLY public.tb_usuario ALTER COLUMN id_us SET DEFAULT nextval('public.tb_usuario_id_us_seq'::regclass);
 ?   ALTER TABLE public.tb_usuario ALTER COLUMN id_us DROP DEFAULT;
       public               postgres    false    232    231            �          0    65542    tb_auditoria 
   TABLE DATA           �   COPY auditoria.tb_auditoria (id_aud, tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud, esquema_aud, activar_aud, trigger_aud) FROM stdin;
 	   auditoria               postgres    false    218   XN                 0    65646 
   tb_carrito 
   TABLE DATA           l   COPY public.tb_carrito (id_carrito, id_usuario, nombre_pr, cantidad, id_estado, fecha_agregado) FROM stdin;
    public               postgres    false    234   �Q       �          0    65548    tb_categoria 
   TABLE DATA           ?   COPY public.tb_categoria (id_cat, descripcion_cat) FROM stdin;
    public               postgres    false    220   �R       �          0    65554    tb_estadocivil 
   TABLE DATA           A   COPY public.tb_estadocivil (id_est, descripcion_est) FROM stdin;
    public               postgres    false    222   4S       �          0    65560 	   tb_pagina 
   TABLE DATA           F   COPY public.tb_pagina (id_pag, descripcion_pag, path_pag) FROM stdin;
    public               postgres    false    224   oS       �          0    65565    tb_parametros 
   TABLE DATA           K   COPY public.tb_parametros (id_par, descripcion_par, valor_par) FROM stdin;
    public               postgres    false    225   $T       �          0    65570 	   tb_perfil 
   TABLE DATA           <   COPY public.tb_perfil (id_per, descripcion_per) FROM stdin;
    public               postgres    false    226   AT       �          0    65575    tb_perfilpagina 
   TABLE DATA           D   COPY public.tb_perfilpagina (id_perpag, id_per, id_pag) FROM stdin;
    public               postgres    false    227   �T       �          0    65579    tb_producto 
   TABLE DATA           `   COPY public.tb_producto (id_pr, id_cat, nombre_pr, cantidad_pr, precio_pr, foto_pr) FROM stdin;
    public               postgres    false    229   �T                 0    65585 
   tb_usuario 
   TABLE DATA           n   COPY public.tb_usuario (id_us, id_per, id_est, nombre_us, cedula_us, correo_us, clave_us, estado) FROM stdin;
    public               postgres    false    231   �V                  0    0    tb_auditoria_id_aud_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('auditoria.tb_auditoria_id_aud_seq', 32, true);
       	   auditoria               postgres    false    219                       0    0    tb_carrito_id_carrito_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.tb_carrito_id_carrito_seq', 47, true);
          public               postgres    false    233                       0    0    tb_categoria_id_cat_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.tb_categoria_id_cat_seq', 5, true);
          public               postgres    false    221                       0    0    tb_estadocivil_id_est_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.tb_estadocivil_id_est_seq', 1, false);
          public               postgres    false    223                       0    0    tb_perfilpagina_id_perpag_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tb_perfilpagina_id_perpag_seq', 7, true);
          public               postgres    false    228                       0    0    tb_producto_id_pr_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.tb_producto_id_pr_seq', 27, true);
          public               postgres    false    230                       0    0    tb_usuario_id_us_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.tb_usuario_id_us_seq', 12, true);
          public               postgres    false    232            Y           2606    65598    tb_auditoria pk_tb_auditoria 
   CONSTRAINT     a   ALTER TABLE ONLY auditoria.tb_auditoria
    ADD CONSTRAINT pk_tb_auditoria PRIMARY KEY (id_aud);
 I   ALTER TABLE ONLY auditoria.tb_auditoria DROP CONSTRAINT pk_tb_auditoria;
    	   auditoria                 postgres    false    218            `           2606    65656    tb_carrito tb_carrito_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tb_carrito
    ADD CONSTRAINT tb_carrito_pkey PRIMARY KEY (id_carrito);
 D   ALTER TABLE ONLY public.tb_carrito DROP CONSTRAINT tb_carrito_pkey;
       public                 postgres    false    234            \           2606    65600    tb_categoria tb_categoria_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tb_categoria
    ADD CONSTRAINT tb_categoria_pkey PRIMARY KEY (id_cat);
 H   ALTER TABLE ONLY public.tb_categoria DROP CONSTRAINT tb_categoria_pkey;
       public                 postgres    false    220            ^           2606    65602    tb_producto tb_producto_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.tb_producto
    ADD CONSTRAINT tb_producto_pkey PRIMARY KEY (id_pr);
 F   ALTER TABLE ONLY public.tb_producto DROP CONSTRAINT tb_producto_pkey;
       public                 postgres    false    229            Z           1259    65603    tb_auditoria_pk    INDEX     T   CREATE UNIQUE INDEX tb_auditoria_pk ON auditoria.tb_auditoria USING btree (id_aud);
 &   DROP INDEX auditoria.tb_auditoria_pk;
    	   auditoria                 postgres    false    218            b           2620    65604     tb_producto tb_producto_tg_audit    TRIGGER     �   CREATE TRIGGER tb_producto_tg_audit AFTER INSERT OR DELETE OR UPDATE ON public.tb_producto FOR EACH ROW EXECUTE FUNCTION public.fn_log_audit();
 9   DROP TRIGGER tb_producto_tg_audit ON public.tb_producto;
       public               postgres    false    229    235            a           2606    65605 #   tb_producto tb_producto_id_cat_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_producto
    ADD CONSTRAINT tb_producto_id_cat_fkey FOREIGN KEY (id_cat) REFERENCES public.tb_categoria(id_cat);
 M   ALTER TABLE ONLY public.tb_producto DROP CONSTRAINT tb_producto_id_cat_fkey;
       public               postgres    false    220    4700    229            �   E  x���n�0Ư�SX\;q
��FE���_M�4�ģ�B�9I+T���=B_lN	�qp��bW(D����;'�����o��Q��9s�.��>��W�W �#P^�$�WP^$|9t}��}���2���y�$9��槠w� ။�uN.�οN����,,�^]�p#JЈ�e�'�uB��1����)M�k���eJ¼
��p<�8����;��<�!��
(��g"�,6��
�X����w6�{xq-�S�v��#�R���jյ�،��x&��(蜤U �� 蚁�F����&����K�ҵP��{�|���M�޾Ñ�%+0d�sHk�ҽm�z���U߿�Vm���'�䕒{�ޭ����M�C��P<�|z�C��9�:�X�Fq<�ƚ�$�ZK1O�U�2'�
�$�aގ+괬�D#�D��-딶��y:+i%��(��l]r��Z�<P��â6� �(ϱ�l�T�Nw5�āFqF��Ȕ%�)bf<ϩ ���g�HVދ	�(��i9�����9�[	������+�S&H��2�Z��S�b�N�YIb����ȓ,,�����-y�m�\�V������!A+iV�ni/�(�g �~���,t�m�혚~��f%�93Cd�8d!��Ǐ�����4~�!Ǩ��]��b︰�L��� �h?�D�/Dd���/��sG�T��:�;)g%I�	��\��Q�d!���|�.I��f��7,�����u'0�@�T���_��T�u�Hʌ�J2�$������a�l���X5�-��8�X��6�ќv�WP���y����MN���%�W*���C�=a����z�?_�)�         &  x���OJ�@�u�s���$���XA��p�&��T�Tȹ<�s"�V\X������>F�����~���.���}?��zbos���u�ԛi���~�!f�.��9y�>@H�2+��"�xl6��{g�۸����������^?5�ā|u�S��4�iW�[��hP�h�Pi�ʪS�%�J`q��F�@��'P�JR��t��-��T+{1B�ֺ�]\����B�>�t�zR��4�.�!�2]��ё4 N5
@�I�rʩ�JԈ�p��l��n�����zb1O��	
��      �   A   x�3��LI��*MM�/�2��ML�L�2�t���M�2�H�9�6�4'��˔38�(3��+F��� �h      �   +   x�3�tvvt��2���	q��2�t��r�	��qqq �/      �   �   x��п
�0��9y�>AS�A馝�q�LCi{��*���h�������j�~�,�]x�Ȫ	�1=Z�;d�ʢ,L |9+x{��Ґkg���NՎ��ٱ�1)d��bd�j �Y��@�6�~Y�l��X$H���q�������s���8��hQ1x͵�o�l      �      x������ � �      �   0   x�3�tt����	rt��2�t��t�q�2�s�sq	��qqq �!	�      �   .   x���  �wn���a�9�ǒK���f���p4G��F����      �   �  x�}�_n�0Ɵ'����g��<B[�"
� �R4M�$��v�U��8B/��d7�����yf<�!�o�i�do%O�ۓ4M+��c�e<���y''.p����d%���U��Cy��j�?]�/$�%Y�Q����P9�cl<Ɲ���
�|�Ьv�Q�t��z��fw���62��f<w���u�W@7.�$p�Z���Tߓfo�g���E3���� � ��B/�𩫃����ڷ�����[[�/g猣׭w���>U?�����f���3%��B��z���N�J����Acc�p���y������p��$=�K�QO��9����Ϙ6̗5���XȽ����#��0a#vz.2���z5�ڶ��>a�CI�6uj+z��f��ae!&�L�>��}D	��y�!�94�3��g4�hug!�a:;Տ0��̂N�         �   x�u�An�0 ϛW��k;�s#��B��J�[//���B__�DU$T�6Ҭg���a]��]�y�^WR2�\�{C?,[��i���;�&|���#0�0\�Q�G1ˤ�Z��w�3s2�h�k��e�����=Ȣ ���{�aQQ(���ư<�۟��������Y��U!snb~�����GS֛�t]��uS��t�Mf�l�O��H���{b�     