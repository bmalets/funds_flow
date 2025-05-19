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
-- Name: fund_load_attempts_import_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.fund_load_attempts_import_status AS ENUM (
    'pending',
    'failed',
    'created'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    external_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: fund_load_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fund_load_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    fund_load_attempts_import_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    amount_cents bigint NOT NULL,
    attempted_at timestamp(6) without time zone NOT NULL,
    external_id bigint NOT NULL,
    accepted boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: fund_load_attempts_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fund_load_attempts_imports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    fund_load_attempts_count bigint DEFAULT 0 NOT NULL,
    status public.fund_load_attempts_import_status DEFAULT 'pending'::public.fund_load_attempts_import_status NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: fund_load_attempts_imports fund_load_attempts_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fund_load_attempts_imports
    ADD CONSTRAINT fund_load_attempts_imports_pkey PRIMARY KEY (id);


--
-- Name: fund_load_attempts fund_load_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fund_load_attempts
    ADD CONSTRAINT fund_load_attempts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_customers_on_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_external_id ON public.customers USING btree (external_id);


--
-- Name: index_fund_load_attempts_on_customer_id_and_attempted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fund_load_attempts_on_customer_id_and_attempted_at ON public.fund_load_attempts USING btree (customer_id, attempted_at);


--
-- Name: index_fund_load_attempts_on_customer_id_and_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fund_load_attempts_on_customer_id_and_external_id ON public.fund_load_attempts USING btree (customer_id, external_id);


--
-- Name: index_fund_load_attempts_on_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fund_load_attempts_on_external_id ON public.fund_load_attempts USING btree (external_id);


--
-- Name: index_fund_load_attempts_on_fund_load_attempts_import_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fund_load_attempts_on_fund_load_attempts_import_id ON public.fund_load_attempts USING btree (fund_load_attempts_import_id);


--
-- Name: fund_load_attempts fk_rails_6068d88f5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fund_load_attempts
    ADD CONSTRAINT fk_rails_6068d88f5d FOREIGN KEY (fund_load_attempts_import_id) REFERENCES public.fund_load_attempts_imports(id);


--
-- Name: fund_load_attempts fk_rails_9e66b3f3f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fund_load_attempts
    ADD CONSTRAINT fk_rails_9e66b3f3f0 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250518232420');

