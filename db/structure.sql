--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: contacts_before_insert_update_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION contacts_before_insert_update_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    new.content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.content,''));
    RETURN NEW;
END;
$$;


--
-- Name: not_ready_contacts_before_insert_update_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION not_ready_contacts_before_insert_update_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    new.not_ready_content_tsearch := to_tsvector('pg_catalog.simple', coalesce(new.not_ready_content,''));
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    super_admin boolean DEFAULT false NOT NULL,
    agreed_to_terms boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id integer,
    invitations_count integer DEFAULT 0,
    organization_id integer NOT NULL,
    name character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidacies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE candidacies (
    id integer NOT NULL,
    experience integer,
    skin_test boolean,
    availability integer,
    transportation integer,
    zipcode character varying,
    cpr_first_aid boolean,
    certification integer,
    person_id integer NOT NULL,
    inquiry integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_id integer,
    progress double precision DEFAULT 0.0 NOT NULL,
    state integer DEFAULT 0 NOT NULL
);


--
-- Name: candidacies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE candidacies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidacies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE candidacies_id_seq OWNED BY candidacies.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    person_id integer NOT NULL,
    organization_id integer NOT NULL,
    subscribed boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    screened boolean DEFAULT false NOT NULL,
    content text,
    content_tsearch tsvector,
    candidate boolean DEFAULT false NOT NULL,
    last_reply_at timestamp without time zone,
    not_ready_content text,
    not_ready_content_tsearch tsvector
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: ideal_candidate_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ideal_candidate_suggestions (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ideal_candidate_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ideal_candidate_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ideal_candidate_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ideal_candidate_suggestions_id_seq OWNED BY ideal_candidate_suggestions.id;


--
-- Name: ideal_candidate_zipcodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ideal_candidate_zipcodes (
    id integer NOT NULL,
    value character varying NOT NULL,
    ideal_candidate_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ideal_candidate_zipcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ideal_candidate_zipcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ideal_candidate_zipcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ideal_candidate_zipcodes_id_seq OWNED BY ideal_candidate_zipcodes.id;


--
-- Name: ideal_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ideal_candidates (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ideal_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ideal_candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ideal_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ideal_candidates_id_seq OWNED BY ideal_candidates.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    full_street_address character varying NOT NULL,
    city character varying NOT NULL,
    state character varying NOT NULL,
    state_code character varying,
    postal_code character varying NOT NULL,
    country character varying NOT NULL,
    country_code character varying,
    organization_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id integer NOT NULL,
    sid character varying NOT NULL,
    body text,
    direction character varying NOT NULL,
    sent_at timestamp without time zone,
    external_created_at timestamp without time zone,
    organization_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    manual boolean DEFAULT false NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying NOT NULL,
    twilio_account_sid character varying,
    twilio_auth_token character varying,
    phone_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recruiter_id integer,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE people (
    id integer NOT NULL,
    full_name character varying,
    nickname character varying NOT NULL,
    phone_number character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    zipcode_id integer
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE people_id_seq OWNED BY people.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id integer,
    organization_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: recruiting_ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recruiting_ads (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recruiting_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recruiting_ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruiting_ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recruiting_ads_id_seq OWNED BY recruiting_ads.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: zipcodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE zipcodes (
    id integer NOT NULL,
    zipcode character varying NOT NULL,
    zipcode_type character varying,
    default_city character varying,
    county_fips character varying,
    county_name character varying,
    state_abbreviation character varying,
    state character varying,
    latitude double precision,
    longitude double precision,
    "precision" character varying
);


--
-- Name: zipcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zipcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zipcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zipcodes_id_seq OWNED BY zipcodes.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: candidacies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidacies ALTER COLUMN id SET DEFAULT nextval('candidacies_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: ideal_candidate_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_suggestions ALTER COLUMN id SET DEFAULT nextval('ideal_candidate_suggestions_id_seq'::regclass);


--
-- Name: ideal_candidate_zipcodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_zipcodes ALTER COLUMN id SET DEFAULT nextval('ideal_candidate_zipcodes_id_seq'::regclass);


--
-- Name: ideal_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidates ALTER COLUMN id SET DEFAULT nextval('ideal_candidates_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN id SET DEFAULT nextval('people_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: recruiting_ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recruiting_ads ALTER COLUMN id SET DEFAULT nextval('recruiting_ads_id_seq'::regclass);


--
-- Name: zipcodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zipcodes ALTER COLUMN id SET DEFAULT nextval('zipcodes_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: candidacies candidacies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidacies
    ADD CONSTRAINT candidacies_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: ideal_candidate_suggestions ideal_candidate_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_suggestions
    ADD CONSTRAINT ideal_candidate_suggestions_pkey PRIMARY KEY (id);


--
-- Name: ideal_candidate_zipcodes ideal_candidate_zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_zipcodes
    ADD CONSTRAINT ideal_candidate_zipcodes_pkey PRIMARY KEY (id);


--
-- Name: ideal_candidates ideal_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidates
    ADD CONSTRAINT ideal_candidates_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: recruiting_ads recruiting_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recruiting_ads
    ADD CONSTRAINT recruiting_ads_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: zipcodes zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zipcodes
    ADD CONSTRAINT zipcodes_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_email ON accounts USING btree (email);


--
-- Name: index_accounts_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_invitation_token ON accounts USING btree (invitation_token);


--
-- Name: index_accounts_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_invitations_count ON accounts USING btree (invitations_count);


--
-- Name: index_accounts_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_invited_by_id ON accounts USING btree (invited_by_id);


--
-- Name: index_accounts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_organization_id ON accounts USING btree (organization_id);


--
-- Name: index_accounts_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_reset_password_token ON accounts USING btree (reset_password_token);


--
-- Name: index_candidacies_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidacies_on_person_id ON candidacies USING btree (person_id);


--
-- Name: index_contacts_on_content_tsearch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_content_tsearch ON contacts USING gin (content_tsearch) WHERE (candidate = true);


--
-- Name: index_contacts_on_not_ready_content_tsearch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_not_ready_content_tsearch ON contacts USING gin (not_ready_content_tsearch) WHERE (candidate = false);


--
-- Name: index_contacts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_organization_id ON contacts USING btree (organization_id);


--
-- Name: index_contacts_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_person_id ON contacts USING btree (person_id);


--
-- Name: index_contacts_on_person_id_and_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_person_id_and_organization_id ON contacts USING btree (person_id, organization_id);


--
-- Name: index_ideal_candidate_suggestions_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ideal_candidate_suggestions_on_organization_id ON ideal_candidate_suggestions USING btree (organization_id);


--
-- Name: index_ideal_candidate_zipcodes_on_ideal_candidate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ideal_candidate_zipcodes_on_ideal_candidate_id ON ideal_candidate_zipcodes USING btree (ideal_candidate_id);


--
-- Name: index_ideal_candidate_zipcodes_on_ideal_candidate_id_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ideal_candidate_zipcodes_on_ideal_candidate_id_and_value ON ideal_candidate_zipcodes USING btree (ideal_candidate_id, value);


--
-- Name: index_ideal_candidates_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ideal_candidates_on_organization_id ON ideal_candidates USING btree (organization_id);


--
-- Name: index_locations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_organization_id ON locations USING btree (organization_id);


--
-- Name: index_messages_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_organization_id ON messages USING btree (organization_id);


--
-- Name: index_messages_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_person_id ON messages USING btree (person_id);


--
-- Name: index_messages_on_sid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_messages_on_sid ON messages USING btree (sid);


--
-- Name: index_organizations_on_phone_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_phone_number ON organizations USING btree (phone_number);


--
-- Name: index_organizations_on_recruiter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_recruiter_id ON organizations USING btree (recruiter_id);


--
-- Name: index_people_on_zipcode_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_zipcode_id ON people USING btree (zipcode_id);


--
-- Name: index_pg_search_documents_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_organization_id ON pg_search_documents USING btree (organization_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_recruiting_ads_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiting_ads_on_organization_id ON recruiting_ads USING btree (organization_id);


--
-- Name: contacts contacts_before_insert_update_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER contacts_before_insert_update_row_tr BEFORE INSERT OR UPDATE ON contacts FOR EACH ROW EXECUTE PROCEDURE contacts_before_insert_update_row_tr();


--
-- Name: contacts not_ready_contacts_before_insert_update_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER not_ready_contacts_before_insert_update_row_tr BEFORE INSERT OR UPDATE ON contacts FOR EACH ROW EXECUTE PROCEDURE not_ready_contacts_before_insert_update_row_tr();


--
-- Name: candidacies fk_rails_01a916123b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY candidacies
    ADD CONSTRAINT fk_rails_01a916123b FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: organizations fk_rails_180b619402; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT fk_rails_180b619402 FOREIGN KEY (recruiter_id) REFERENCES accounts(id);


--
-- Name: accounts fk_rails_1ceb778440; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_1ceb778440 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: messages fk_rails_41c70a97c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_41c70a97c6 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: people fk_rails_6b501a6402; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT fk_rails_6b501a6402 FOREIGN KEY (zipcode_id) REFERENCES zipcodes(id);


--
-- Name: recruiting_ads fk_rails_6b5e156a02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recruiting_ads
    ADD CONSTRAINT fk_rails_6b5e156a02 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: ideal_candidate_suggestions fk_rails_76d371f451; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_suggestions
    ADD CONSTRAINT fk_rails_76d371f451 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: messages fk_rails_835d3e2df6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_835d3e2df6 FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: locations fk_rails_84778edc55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT fk_rails_84778edc55 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: contacts fk_rails_885008c105; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT fk_rails_885008c105 FOREIGN KEY (person_id) REFERENCES people(id);


--
-- Name: ideal_candidates fk_rails_c7a0339d90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidates
    ADD CONSTRAINT fk_rails_c7a0339d90 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: contacts fk_rails_d2a970fc50; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT fk_rails_d2a970fc50 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: pg_search_documents fk_rails_eda88ce3b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT fk_rails_eda88ce3b8 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: ideal_candidate_zipcodes fk_rails_f350bdf885; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ideal_candidate_zipcodes
    ADD CONSTRAINT fk_rails_f350bdf885 FOREIGN KEY (ideal_candidate_id) REFERENCES ideal_candidates(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170217192655'),
('20170217192712'),
('20170217194255'),
('20170217194557'),
('20170217195514'),
('20170217195937'),
('20170217200549'),
('20170217200916'),
('20170217200920'),
('20170218022305'),
('20170218030122'),
('20170218133128'),
('20170218181324'),
('20170221142320'),
('20170222215406'),
('20170223160528'),
('20170224220539'),
('20170225171500'),
('20170225200724'),
('20170225221058'),
('20170302191131'),
('20170302203723'),
('20170302203823'),
('20170302203927'),
('20170310141555'),
('20170310144756'),
('20170310203734'),
('20170310234243'),
('20170312162833'),
('20170316123919'),
('20170316150805'),
('20170404173405'),
('20170404174929');


