failed to get console mode for stdout: The handle is invalid.
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE hoteldb;




--
-- Drop roles
--

DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:RUr+Ud0/bwg6UzOaitx+5g==$M/hSJU6i0LhBTECc6zyJXgpZlBVCZuaL7ersEPgr1w8=:hQggsYM/bPYvNXrCF/FnEu0euV+m7nKyrrHk5o3KplY=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "hoteldb" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hoteldb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE hoteldb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE hoteldb OWNER TO postgres;

\connect hoteldb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_min_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_min_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  

BEGIN  

    UPDATE hotels  

    SET min_price = (  

        SELECT MIN(price_per_night)  

        FROM rooms  

        WHERE hotel_id = NEW.hotel_id  

    )  

    WHERE id = NEW.hotel_id;  

  

    RETURN NEW;  

END;  

$$;


ALTER FUNCTION public.update_min_price() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    id integer NOT NULL,
    name text,
    address text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    city text,
    country text,
    rating numeric,
    phone text,
    email text,
    min_price bigint
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotels_id_seq OWNER TO postgres;

--
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotels_id_seq OWNED BY public.hotels.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    path_to_photo text,
    room_id bigint,
    hotel_id bigint
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.photos_id_seq OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.photos_id_seq OWNED BY public.photos.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    capacity bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    room_number bigint,
    room_type text,
    price_per_night bigint,
    description text,
    hotel_id bigint
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO postgres;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: hotels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels ALTER COLUMN id SET DEFAULT nextval('public.hotels_id_seq'::regclass);


--
-- Name: photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos ALTER COLUMN id SET DEFAULT nextval('public.photos_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotels (id, name, address, created_at, updated_at, deleted_at, city, country, rating, phone, email, min_price) FROM stdin;
3	╨У╨╛╤Б╤В╨╕╨╜╨╕╤Ж╨░ ╨б╨╕╨▒╨╕╤А╤М	╨┐╤А╨╛╤Б╨┐╨╡╨║╤В ╨Ъ╤А╨░╤Б╨╜╨╛╤П╤А╤Б╨║╨╕╨╣, ╨┤. 5	2024-11-24 13:21:17.118913+00	2024-11-24 13:21:17.118913+00	\N	╨Ъ╤А╨░╤Б╨╜╨╛╤П╤А╤Б╨║	╨а╨╛╤Б╤Б╨╕╤П	3.799999952316284	+7 (391) 234-56-78	info@siberia-hotel.ru	2000
1	╨У╨╛╤Б╤В╨╕╨╜╨╕╤Ж╨░ ╨Я╨╡╤В╤А╨╛╨▓╤Б╨║╨░╤П	╤Г╨╗. ╨Я╤Г╤И╨║╨╕╨╜╨░, ╨┤. 10	2024-11-24 13:21:00.79868+00	2024-11-24 13:21:00.79868+00	\N	╨Ь╨╛╤Б╨║╨▓╨░	╨а╨╛╤Б╤Б╨╕╤П	4.5	+7 (495) 123-45-67	info@petrovskaya.ru	1500
2	╨Ю╤В╨╡╨╗╤М ╨Ч╨╛╨╗╨╛╤В╨░╤П ╨а╤Л╨▒╨║╨░	╤Г╨╗. ╨Ы╨╡╨╜╨╕╨╜╨░, ╨┤. 15	2024-11-24 13:21:10.413774+00	2024-11-24 13:21:10.413774+00	\N	╨б╨░╨╜╨║╤В-╨Я╨╡╤В╨╡╤А╨▒╤Г╤А╨│	╨а╨╛╤Б╤Б╨╕╤П	4	+7 (812) 765-43-21	contact@goldfish.ru	2000
4	╨Ъ╤Г╤А╨╛╤А╤В╨╜╤Л╨╣ ╨Ю╤В╨╡╨╗╤М ╨Ь╨╡╤З╤В╨░	╤Г╨╗. ╨Ь╨╛╤А╤Б╨║╨░╤П, ╨┤. 20	2024-11-24 13:21:24.967867+00	2024-11-24 13:21:24.967867+00	\N	╨б╨╛╤З╨╕	╨а╨╛╤Б╤Б╨╕╤П	5	+7 (862) 987-65-43	reservations@dreamresort.ru	2000
5	╨У╨╛╤Б╤В╨╕╨╜╨╕╤Ж╨░ ╨г╤А╨░╨╗	╤Г╨╗. ╨У╨░╨│╨░╤А╨╕╨╜╨░, ╨┤. 8	2024-11-24 13:21:30.362101+00	2024-11-24 13:21:30.362101+00	\N	╨Х╨║╨░╤В╨╡╤А╨╕╨╜╨▒╤Г╤А╨│	╨а╨╛╤Б╤Б╨╕╤П	4.199999809265137	+7 (343) 567-89-01	info@uralhotel.ru	2000
6	╨С╨╕╨╖╨╜╨╡╤Б ╨Ю╤В╨╡╨╗╤М ╨ж╨╡╨╜╤В╤А	╤Г╨╗. ╨в╨▓╨╡╤А╤Б╨║╨░╤П, ╨┤. 12	2024-11-24 13:21:37.311463+00	2024-11-24 13:21:37.311463+00	\N	╨Ь╨╛╤Б╨║╨▓╨░	╨а╨╛╤Б╤Б╨╕╤П	4.300000190734863	+7 (495) 321-54-76	business@centerhotel.ru	2000
7	╨Я╨░╨╜╤Б╨╕╨╛╨╜╨░╤В ╨Ю╤Б╤В╤А╨╛╨▓╨╛╨║ ╨б╤З╨░╤Б╤В╤М╤П	╨┐╨╡╤А. ╨б╨╛╨╗╨╜╨╡╤З╨╜╤Л╨╣, ╨┤. 3	2024-11-24 13:22:32.475699+00	2024-11-24 13:22:32.475699+00	\N	╨Ъ╨░╨╗╨╕╨╜╨╕╨╜╨│╤А╨░╨┤	╨а╨╛╤Б╤Б╨╕╤П	3.9000000953674316	+7 (401) 234-56-78	info@happishelter.ru	2000
\.


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.photos (id, created_at, updated_at, deleted_at, path_to_photo, room_id, hotel_id) FROM stdin;
3	2024-11-24 13:21:17.125645+00	2024-11-27 17:40:56.087009+00	\N	https://cdn.worldota.net/t/640x400/extranet/ca/25/ca25a6495eba05fd9add66e5692a3a37259fe6fd.jpeg	\N	3
1	2024-11-24 13:21:00.842554+00	2024-11-27 17:42:07.188881+00	\N	https://cdn.worldota.net/t/640x400/extranet/9e/5f/9e5f54f5d2720e010dcd187bbc84383b4fcac23b.jpeg	\N	1
2	2024-11-24 13:21:10.420186+00	2024-11-27 17:43:26.686493+00	\N	https://cdn.worldota.net/t/640x400/extranet/ce/41/ce41b03e00f6de673644bb2dba47d5e09f25bec0.jpeg	\N	2
4	2024-11-24 13:21:25.018775+00	2024-11-27 17:45:26.966077+00	\N	https://cdn.worldota.net/t/640x400/extranet/b2/f7/b2f764cfffa1b25ec6b365a596e559559ca84c4f.jpeg	\N	4
5	2024-11-24 13:21:30.369111+00	2024-11-27 17:45:46.964078+00	\N	https://cdn.worldota.net/t/640x400/extranet/93/10/9310eaba61048b20c2b99a1d745d73347fc28f9c.jpeg	\N	5
6	2024-11-24 13:21:37.358021+00	2024-11-27 17:46:04.202394+00	\N	https://cdn.worldota.net/t/640x400/extranet/31/b4/31b491b28160f36f3a2ac56d102373fd05f474d5.jpeg	\N	6
7	2024-11-24 13:22:32.483375+00	2024-11-27 17:46:26.385874+00	\N	https://cdn.worldota.net/t/640x400/extranet/1c/a5/1ca58d3f4322213ba11f64cced18f94bd4925ed5.jpeg	\N	7
8	2024-11-29 14:27:35.095023+00	2024-11-29 14:27:35.095023+00	\N	https://cdn.worldota.net/t/640x400/extranet/96/a5/96a5cafaab788f7f7829948a4b5f47df1ab99abf.jpeg	3	\N
9	2024-11-29 14:52:24.891145+00	2024-11-29 14:52:24.891145+00	\N	https://cdn.worldota.net/t/640x400/extranet/78/5d/785d68da549e0c9fdc48cdb66eca4e13a8372634.jpeg	4	\N
10	2024-11-29 14:54:22.461309+00	2024-11-29 14:54:22.461309+00	\N	https://cdn.worldota.net/t/640x400/extranet/ba/61/ba61330a277ee8297aaa72ff28350b6b5ba6f499.jpeg	5	\N
11	2024-11-29 14:54:34.854856+00	2024-11-29 14:54:34.854856+00	\N	https://cdn.worldota.net/t/640x400/extranet/c4/3d/c43da41cb01d0036691b89c88faa68616c96d1ca.jpeg	6	\N
12	2024-11-29 14:54:51.242009+00	2024-11-29 14:54:51.242009+00	\N	https://cdn.worldota.net/t/640x400/extranet/b6/6e/b66e3d80d630f2fdea39edb331eae9559d233c4c.jpeg	7	\N
13	2024-11-29 14:55:15.594757+00	2024-11-29 14:55:15.594757+00	\N	https://cdn.worldota.net/t/640x400/extranet/64/0a/640a2b6f6e4e8ed67cb0dd8480b915537d2ebed3.jpega	8	\N
16	2024-11-29 14:57:12.224673+00	2024-11-29 14:57:12.224673+00	\N	https://cdn.worldota.net/t/640x400/extranet/d8/62/d86261e13b27724e4fa47b8880b5081a3847eb11.jpeg	10	\N
17	2024-11-29 15:00:48.785851+00	2024-11-29 15:03:48.084038+00	\N	https://cdn.worldota.net/t/640x400/extranet/60/f1/60f1e2a9272325e5babd06fd7f1dc9f8bbe6b492.jpeg	11	\N
18	2024-11-29 15:00:59.757041+00	2024-11-29 15:04:05.330279+00	\N	https://cdn.worldota.net/t/640x400/extranet/c8/9d/c89d79c65fc98677c947ca4a3336ecebfd490db4.jpeg	12	\N
19	2024-11-29 15:05:21.169255+00	2024-11-29 15:05:21.169255+00	\N	https://cdn.worldota.net/t/640x400/extranet/31/b4/31b491b28160f36f3a2ac56d102373fd05f474d5.jpeg	13	\N
20	2024-11-29 15:05:49.454314+00	2024-11-29 15:05:49.454314+00	\N	https://cdn.worldota.net/t/640x400/extranet/aa/4b/aa4b76ba5acd43c1a04a284fb74f08960dfa3605.jpeg	14	\N
21	2024-11-29 15:06:07.899191+00	2024-11-29 15:06:07.899191+00	\N	https://cdn.worldota.net/t/640x400/extranet/65/ec/65ec8895a70482d8c6520452c910a727d651f86e.jpeg	15	\N
22	2024-11-29 15:06:23.35428+00	2024-11-29 15:06:23.35428+00	\N	https://cdn.worldota.net/t/640x400/extranet/49/0e/490e18074212aeb3182746e7ed3c91ba78e68f64.jpeg	16	\N
23	2024-11-29 15:06:44.454937+00	2024-11-29 15:06:44.454937+00	\N	https://cdn.worldota.net/t/640x400/extranet/04/21/04216c669eecb057a3260bbdc679093c8145b2d2.jpeg	17	\N
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (id, capacity, created_at, updated_at, deleted_at, room_number, room_type, price_per_night, description, hotel_id) FROM stdin;
3	2	2024-11-24 13:46:03.528823+00	2024-11-24 13:46:03.528823+00	\N	101	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	1
4	2	2024-11-24 13:47:09.087015+00	2024-11-24 13:47:09.087015+00	\N	102	Standard	2500	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	1
5	2	2024-11-24 13:47:31.96929+00	2024-11-24 13:47:31.96929+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	1
6	2	2024-11-24 13:47:42.024857+00	2024-11-24 13:47:42.024857+00	\N	301	Suite	8000	╨а╨╛╤Б╨║╨╛╤И╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨│╨╛╤Б╤В╨╕╨╜╨╛╨╣.	1
7	4	2024-11-24 13:47:54.415024+00	2024-11-24 13:47:54.415024+00	\N	401	Family	6000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╤З╨╡╤В╨▓╨╡╤А╤Л╤Е.	1
8	2	2024-11-24 13:48:05.945349+00	2024-11-24 13:48:05.945349+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	1
10	2	2024-11-24 13:48:29.507973+00	2024-11-24 13:48:29.507973+00	\N	502	Economy	1500	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	1
11	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	2
12	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	2
13	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	2
14	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	2
15	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	2
16	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	2
17	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	2
18	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	3
19	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	3
20	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	3
21	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	3
22	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	3
23	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	3
24	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	3
25	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	4
26	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	4
27	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	4
28	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	4
29	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	4
30	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	4
31	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	4
32	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	5
33	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	5
34	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	5
35	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	5
36	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	5
37	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	5
38	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	5
39	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	6
40	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	6
41	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	6
42	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	6
43	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	6
44	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	6
45	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	6
46	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	101	Standard	3000	╨Ъ╨╛╨╝╤Д╨╛╤А╤В╨░╨▒╨╡╨╗╤М╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨╛╨┤╨╜╨╛╨╣ ╨┤╨▓╤Г╤Б╨┐╨░╨╗╤М╨╜╨╛╨╣ ╨║╤А╨╛╨▓╨░╤В╤М╤О.	7
47	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	102	Standard	3000	╨г╤О╤В╨╜╤Л╨╣ ╤Б╤В╨░╨╜╨┤╨░╤А╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╨┤╨▓╤Г╨╝╤П ╨╛╨┤╨╜╨╛╤Б╨┐╨░╨╗╤М╨╜╤Л╨╝╨╕ ╨║╤А╨╛╨▓╨░╤В╤П╨╝╨╕.	7
48	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	201	Double	4000	╨Я╤А╨╛╤Б╤В╨╛╤А╨╜╤Л╨╣ ╨┤╨▓╤Г╤Е╨╝╨╡╤Б╤В╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╤Б ╤Б╨╛╨▓╤А╨╡╨╝╨╡╨╜╨╜╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	7
49	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	301	Suite	8000	╨н╨╗╨╡╨│╨░╨╜╤В╨╜╤Л╨╣ ╨╗╤О╨║╤Б ╤Б ╨╛╤В╨┤╨╡╨╗╤М╨╜╨╛╨╣ ╤Б╨┐╨░╨╗╤М╨╜╨╡╨╣ ╨╕ ╨╖╨╛╨╜╨╛╨╣ ╨┤╨╗╤П ╨╛╤В╨┤╤Л╤Е╨░.	7
50	4	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	401	Family	6000	╨г╨┤╨╛╨▒╨╜╤Л╨╣ ╤Б╨╡╨╝╨╡╨╣╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨║╨╛╨╝╤Д╨╛╤А╤В╨╜╨╛╨│╨╛ ╨┐╤А╨╛╨╢╨╕╨▓╨░╨╜╨╕╤П ╤З╨╡╤В╤Л╤А╨╡╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║.	7
51	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	501	Economy	2000	╨н╨║╨╛╨╜╨╛╨╝╨╕╤З╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨╜╨╡╨╛╨▒╤Е╨╛╨┤╨╕╨╝╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	7
52	2	2024-11-24 13:55:11.09572+00	2024-11-24 13:55:11.09572+00	\N	502	Economy	2000	╨Ф╨╛╤Б╤В╤Г╨┐╨╜╤Л╨╣ ╨╜╨╛╨╝╨╡╤А ╨┤╨╗╤П ╨╛╨┤╨╜╨╛╨│╨╛ ╨╕╨╗╨╕ ╨┤╨▓╤Г╤Е ╤З╨╡╨╗╨╛╨▓╨╡╨║ ╤Б ╨▒╨░╨╖╨╛╨▓╤Л╨╝╨╕ ╤Г╨┤╨╛╨▒╤Б╤В╨▓╨░╨╝╨╕.	7
\.


--
-- Name: hotels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_id_seq', 11, true);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.photos_id_seq', 27, true);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_id_seq', 52, true);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: idx_hotels_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_deleted_at ON public.hotels USING btree (deleted_at);


--
-- Name: idx_photos_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_deleted_at ON public.photos USING btree (deleted_at);


--
-- Name: idx_rooms_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_deleted_at ON public.rooms USING btree (deleted_at);


--
-- Name: rooms after_room_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_room_insert AFTER INSERT ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.update_min_price();


--
-- Name: photos fk_hotels_photo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT fk_hotels_photo FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: rooms fk_hotels_rooms; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_hotels_rooms FOREIGN KEY (hotel_id) REFERENCES public.hotels(id);


--
-- Name: photos fk_rooms_photos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT fk_rooms_photos FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

