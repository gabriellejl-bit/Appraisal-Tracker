--
-- PostgreSQL database dump
--

\restrict ScdoMfpErucHm6zSNQAzFouE3Lb3DLiyNZHVXFigU89ixOK8pGj8fms68M8Ld1c

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.11 (Ubuntu 17.11-1.pgdg24.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_realtime_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_realtime_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_realtime_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_realtime_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_realtime_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
    revoke trigger on cron.job_run_details from postgres;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
        set search_path to ''
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
            set search_path to ''
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
    -- Regclass of the table e.g. public.notes
    entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

    -- I, U, D, T: insert, update ...
    action realtime.action = (
        case wal ->> 'action'
            when 'I' then 'INSERT'
            when 'U' then 'UPDATE'
            when 'D' then 'DELETE'
            else 'ERROR'
        end
    );

    -- Is row level security enabled for the table
    is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

    subscriptions realtime.subscription[] = array_agg(subs)
        from
            realtime.subscription subs
        where
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
    claimed_role regrole;
    claims jsonb;

    subscription_id uuid;
    subscription_has_access bool;
    visible_to_subscription_ids uuid[] = '{}';

    -- structured info for wal's columns
    columns realtime.wal_column[];
    -- previous identity values for update/delete
    old_columns realtime.wal_column[];

    error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

    -- Primary jsonb output for record
    output jsonb;

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

begin
    perform set_config('role', null, true);

    columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'columns') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    old_columns =
        array_agg(
            (
                x->>'name',
                x->>'type',
                x->>'typeoid',
                realtime.cast(
                    (x->'value') #>> '{}',
                    coalesce(
                        (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                        (x->>'type')::regtype
                    )
                ),
                (pks ->> 'name') is not null,
                true
            )::realtime.wal_column
        )
        from
            jsonb_array_elements(wal -> 'identity') x
            left join jsonb_array_elements(wal -> 'pk') pks
                on (x ->> 'name') = (pks ->> 'name');

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
        columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(columns) c;

        old_columns =
                array_agg(
                    (
                        c.name,
                        c.type_name,
                        c.type_oid,
                        c.value,
                        c.is_pkey,
                        pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                    )::realtime.wal_column
                )
                from
                    unnest(old_columns) c;

        if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

            for subscription_id, claims in (
                    select
                        subs.subscription_id,
                        subs.claims
                    from
                        unnest(subscriptions) subs
                    where
                        subs.entity = entity_
                        and subs.claims_role = working_role
                        and (
                            realtime.is_visible_through_filters(columns, subs.filters)
                            or (
                              action = 'DELETE'
                              and realtime.is_visible_through_filters(old_columns, subs.filters)
                            )
                        )
            ) loop

                if not is_rls_enabled or action = 'DELETE' then
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

                output = jsonb_build_object(
                    'schema', wal ->> 'schema',
                    'table', wal ->> 'table',
                    'type', action,
                    'commit_timestamp', to_char(
                        ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                        'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                    ),
                    'columns', (
                        select
                            jsonb_agg(
                                jsonb_build_object(
                                    'name', pa.attname,
                                    'type', pt.typname
                                )
                                order by pa.attnum asc
                            )
                        from
                            pg_attribute pa
                            join pg_type pt
                                on pa.atttypid = pt.oid
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
                    )
                )
                -- Add "record" key for insert and update
                || case
                    when action in ('INSERT', 'UPDATE') then
                        jsonb_build_object(
                            'record',
                            (
                                select
                                    jsonb_object_agg(
                                        -- if unchanged toast, get column name and value from old record
                                        coalesce((c).name, (oc).name),
                                        case
                                            when (c).name is null then (oc).value
                                            else (c).value
                                        end
                                    )
                                from
                                    unnest(columns) c
                                    full outer join unnest(old_columns) oc
                                        on (c).name = (oc).name
                                where
                                    coalesce((c).is_selectable, (oc).is_selectable)
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            )
                        )
                    else '{}'::jsonb
                end
                -- Add "old_record" key for update and delete
                || case
                    when action = 'UPDATE' then
                        jsonb_build_object(
                                'old_record',
                                (
                                    select jsonb_object_agg((c).name, (c).value)
                                    from unnest(old_columns) c
                                    where
                                        (c).is_selectable
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                        and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                )
                            )
                    when action = 'DELETE' then
                        jsonb_build_object(
                            'old_record',
                            (
                                select jsonb_object_agg((c).name, (c).value)
                                from unnest(old_columns) c
                                where
                                    (c).is_selectable
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_realtime_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_realtime_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
/*
Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
*/
declare
    op_symbol text = (
        case
            when op = 'eq' then '='
            when op = 'neq' then '!='
            when op = 'lt' then '<'
            when op = 'lte' then '<='
            when op = 'gt' then '>'
            when op = 'gte' then '>='
            when op = 'in' then '= any'
            else 'UNKNOWN OP'
        end
    );
    res boolean;
begin
    execute format(
        'select %L::'|| type_::text || ' ' || op_symbol
        || ' ( %L::'
        || (
            case
                when op = 'in' then type_::text || '[]'
                else type_::text end
        )
        || ')', val_1, val_2) into res;
    return res;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) OWNER TO supabase_realtime_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_realtime_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    new.selected_columns = (
        select array_agg(c order by c)
        from unnest(new.selected_columns) c
    );

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_realtime_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_realtime_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: billing_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_runs (
    id text NOT NULL,
    run_date text NOT NULL,
    user_name text NOT NULL,
    retailer_ids text NOT NULL,
    packet_ids text NOT NULL,
    status text DEFAULT 'completed'::text,
    created text NOT NULL
);


ALTER TABLE public.billing_runs OWNER TO postgres;

--
-- Name: billing_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_statuses (
    id integer NOT NULL,
    name text NOT NULL,
    show_in_dashboard boolean DEFAULT true,
    show_in_reports boolean DEFAULT true
);


ALTER TABLE public.billing_statuses OWNER TO postgres;

--
-- Name: billing_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.billing_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.billing_statuses_id_seq OWNER TO postgres;

--
-- Name: billing_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.billing_statuses_id_seq OWNED BY public.billing_statuses.id;


--
-- Name: id_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.id_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    date_of_issue date NOT NULL,
    identification text NOT NULL,
    description text NOT NULL,
    measurements text NOT NULL,
    photo_path text NOT NULL,
    report_number text NOT NULL
);


ALTER TABLE public.id_reports OWNER TO postgres;

--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    name text NOT NULL,
    display_order integer DEFAULT 0
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: job_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_types (
    id integer NOT NULL,
    name text NOT NULL,
    cost numeric(10,2) DEFAULT 60.00 NOT NULL,
    display_order integer DEFAULT 0
);


ALTER TABLE public.job_types OWNER TO postgres;

--
-- Name: job_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_types_id_seq OWNER TO postgres;

--
-- Name: job_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_types_id_seq OWNED BY public.job_types.id;


--
-- Name: nj_credit_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nj_credit_notes (
    id text NOT NULL,
    nj_statement_id text,
    accounting_ref text,
    subtotal numeric,
    gst numeric,
    total numeric,
    issue_date text,
    status text DEFAULT 'draft'::text,
    created text,
    source_payment_id text
);


ALTER TABLE public.nj_credit_notes OWNER TO postgres;

--
-- Name: nj_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nj_payments (
    id text NOT NULL,
    amount numeric NOT NULL,
    received_date text NOT NULL,
    reference text,
    nj_statement_id text,
    status text DEFAULT 'active'::text,
    created text
);


ALTER TABLE public.nj_payments OWNER TO postgres;

--
-- Name: nj_statement_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nj_statement_lines (
    id text NOT NULL,
    statement_id text,
    line_type text,
    tax_invoice_id text,
    credit_note_id text,
    payment_id text,
    sub_customer_name text,
    amount numeric
);


ALTER TABLE public.nj_statement_lines OWNER TO postgres;

--
-- Name: nj_statements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nj_statements (
    id text NOT NULL,
    period_start text,
    period_end text,
    generated_date text,
    statement_date text,
    subtotal numeric DEFAULT 0,
    gst numeric DEFAULT 0,
    total numeric DEFAULT 0,
    opening_balance numeric DEFAULT 0,
    aging_current numeric DEFAULT 0,
    aging_30 numeric DEFAULT 0,
    aging_60 numeric DEFAULT 0,
    aging_90 numeric DEFAULT 0,
    accounting_ref text,
    status text DEFAULT 'draft'::text,
    created text,
    paid_date text
);


ALTER TABLE public.nj_statements OWNER TO postgres;

--
-- Name: packet_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packet_items (
    id text NOT NULL,
    packet_id text,
    item text NOT NULL,
    job_type_id integer,
    cost numeric(10,2),
    paula_pct integer DEFAULT 0 NOT NULL,
    gabrielle_pct integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.packet_items OWNER TO postgres;

--
-- Name: packets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packets (
    id text NOT NULL,
    date text NOT NULL,
    retailer_id integer,
    customer_ref text NOT NULL,
    surname text NOT NULL,
    created text NOT NULL,
    modified text NOT NULL,
    status_id integer NOT NULL,
    paula_billed boolean DEFAULT false,
    gabby_billed boolean DEFAULT false,
    sub_customer text,
    shipping_run_id text,
    sub_customer_id text
);


ALTER TABLE public.packets OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text NOT NULL,
    appraiser_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: retailer_job_type_costs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retailer_job_type_costs (
    retailer_id integer NOT NULL,
    job_type_id integer NOT NULL,
    cost numeric NOT NULL
);


ALTER TABLE public.retailer_job_type_costs OWNER TO postgres;

--
-- Name: retailers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retailers (
    id integer NOT NULL,
    name text NOT NULL,
    code integer NOT NULL,
    discount_pct numeric DEFAULT 0 NOT NULL,
    combined_billing boolean DEFAULT false,
    requires_shipping boolean DEFAULT false NOT NULL
);


ALTER TABLE public.retailers OWNER TO postgres;

--
-- Name: retailers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.retailers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.retailers_id_seq OWNER TO postgres;

--
-- Name: retailers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.retailers_id_seq OWNED BY public.retailers.id;


--
-- Name: shipping_runs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_runs (
    id text NOT NULL,
    ship_date text NOT NULL,
    shipping_cost numeric DEFAULT 0 NOT NULL,
    tracking_last4 text,
    retailer_id integer,
    sub_customer_name text,
    invoice_number text,
    created text,
    packing_slip_number text,
    sub_customer_id text,
    shipping_cost_billed numeric
);


ALTER TABLE public.shipping_runs OWNER TO postgres;

--
-- Name: sub_customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_customers (
    id text NOT NULL,
    retailer_id integer NOT NULL,
    name text NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    address_line1 text,
    suburb text,
    city text,
    postcode text,
    bill_to_line text
);


ALTER TABLE public.sub_customers OWNER TO postgres;

--
-- Name: tax_invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_invoices (
    id text NOT NULL,
    invoice_number text NOT NULL,
    shipping_run_id text,
    issue_date text NOT NULL,
    retailer_id integer,
    sub_customer_name text,
    status text DEFAULT 'active'::text NOT NULL,
    created text NOT NULL,
    sub_customer_id text,
    nj_statement_id text,
    paid_date text,
    paid_via_payment_id text
);


ALTER TABLE public.tax_invoices OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    colour text NOT NULL,
    gst_registered boolean DEFAULT true,
    gst_rate numeric(5,2) DEFAULT 15.00,
    income_tax_rate numeric(5,2) DEFAULT 33.00,
    active boolean DEFAULT true
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_realtime_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: billing_statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_statuses ALTER COLUMN id SET DEFAULT nextval('public.billing_statuses_id_seq'::regclass);


--
-- Name: job_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_types ALTER COLUMN id SET DEFAULT nextval('public.job_types_id_seq'::regclass);


--
-- Name: retailers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailers ALTER COLUMN id SET DEFAULT nextval('public.retailers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at, custom_claims_allowlist) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
2050fcad-2f14-4ee2-ab6e-570abce647a3	2050fcad-2f14-4ee2-ab6e-570abce647a3	{"sub": "2050fcad-2f14-4ee2-ab6e-570abce647a3", "email": "paula@jamies.co.nz", "email_verified": false, "phone_verified": false}	email	2026-07-01 04:46:22.482832+00	2026-07-01 04:46:22.482896+00	2026-07-01 04:46:22.482896+00	6be73e26-a09d-4704-ac0d-a20055535283
cf9e07b5-34a4-4fe8-88f9-0a6818df681d	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	{"sub": "cf9e07b5-34a4-4fe8-88f9-0a6818df681d", "email": "gabrielle@jamies.co.nz", "email_verified": false, "phone_verified": false}	email	2026-07-01 04:47:51.408237+00	2026-07-01 04:47:51.408294+00	2026-07-01 04:47:51.408294+00	7084e57c-5a9e-4cf3-a823-2a29ce358d96
e6c0d0c1-b88d-465f-be58-63a565dedef3	e6c0d0c1-b88d-465f-be58-63a565dedef3	{"sub": "e6c0d0c1-b88d-465f-be58-63a565dedef3", "email": "gabriellejl@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-07-01 21:20:41.840747+00	2026-07-01 21:20:41.840797+00	2026-07-01 21:20:41.840797+00	9bb13a64-96f7-40f6-abc5-75b5745ef237
7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	{"sub": "7c66f4eb-c3b9-4773-ad14-dd7be65de9b7", "email": "rachel@jamies.co.nz", "email_verified": false, "phone_verified": false}	email	2026-07-02 00:05:22.524911+00	2026-07-02 00:05:22.525003+00	2026-07-02 00:05:22.525003+00	c5b8f5c9-ca81-4dd1-80a9-67f673440930
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
0eaa571d-f420-4ad9-9c5d-eac983927d41	2026-07-02 00:09:54.25341+00	2026-07-02 00:09:54.25341+00	password	d978d17d-3233-4b70-9478-8a1ddd2cf8db
a0c8afb9-5002-4129-a144-10d64df89031	2026-07-02 02:58:15.67266+00	2026-07-02 02:58:15.67266+00	password	3ac049ea-5c78-4653-b221-6da476264309
663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d	2026-07-02 03:00:22.582517+00	2026-07-02 03:00:22.582517+00	password	5cb5e11f-14f2-4bb0-91f3-bf22789a7f2e
2cf8b78f-75df-4b81-9a47-fdf6032f70a0	2026-07-02 03:04:12.970984+00	2026-07-02 03:04:12.970984+00	password	26eec57b-f4b3-489e-a2d6-4c25bafefc9d
a288011b-11b3-4bf2-93e9-1dd9e49e659e	2026-07-02 04:53:53.361352+00	2026-07-02 04:53:53.361352+00	password	fe2a9a35-862e-4d95-a6e4-a2f601fa8f49
ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3	2026-07-03 00:29:05.522913+00	2026-07-03 00:29:05.522913+00	password	3b7f8a58-1c0f-4561-8503-59390f1be880
1c3181be-21f7-4eae-831b-e6891e308bda	2026-07-13 02:52:00.014371+00	2026-07-13 02:52:00.014371+00	password	0d7a5689-1825-4e2d-b55f-28f900ffcc9d
71c5c60e-0405-4c23-8fed-f3fd8694849d	2026-08-04 00:29:57.903537+00	2026-08-04 00:29:57.903537+00	password	43fb3df2-4ded-4c40-bfa6-6025b48019d2
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	64	aiqrczu4v6rc	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-24 22:52:35.443734+00	2026-07-25 00:39:36.154585+00	o6ze7cohu7lw	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	56	imf6fihj4ypa	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-21 03:39:20.449495+00	2026-07-27 00:44:54.841602+00	tsujgfyjgsv6	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	60	y3hwkadwxn4s	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-21 23:04:48.584744+00	2026-07-27 05:08:45.060267+00	3mdj46irlxod	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	59	f5fwybotur7q	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-21 07:18:34.957964+00	2026-07-28 22:40:27.833217+00	7ww6ik6sfkri	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	14	iwqhd2zqkkam	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	f	2026-07-02 00:09:54.247687+00	2026-07-02 00:09:54.247687+00	\N	0eaa571d-f420-4ad9-9c5d-eac983927d41
00000000-0000-0000-0000-000000000000	15	5yjlnozsckm4	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	f	2026-07-02 02:58:15.655161+00	2026-07-02 02:58:15.655161+00	\N	a0c8afb9-5002-4129-a144-10d64df89031
00000000-0000-0000-0000-000000000000	18	747hsuj3vhvd	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	f	2026-07-02 03:04:12.966676+00	2026-07-02 03:04:12.966676+00	\N	2cf8b78f-75df-4b81-9a47-fdf6032f70a0
00000000-0000-0000-0000-000000000000	20	67yyito6ifki	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-03 00:29:05.473426+00	2026-07-03 03:29:42.845318+00	\N	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	21	ccszalx5v2e7	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-03 03:29:42.85759+00	2026-07-03 05:28:14.019331+00	67yyito6ifki	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	22	3awhkvtabobo	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-03 05:28:14.036989+00	2026-07-03 22:05:36.313515+00	ccszalx5v2e7	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	23	25nizavlcid7	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-03 22:05:36.335871+00	2026-07-04 00:27:10.86345+00	3awhkvtabobo	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	24	dc2bfnmsgtsm	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-04 00:27:10.871993+00	2026-07-04 02:18:43.549565+00	25nizavlcid7	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	19	o2wf2smxjcbo	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-02 04:53:53.34037+00	2026-07-08 00:56:36.992004+00	\N	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	26	wf5mpwezfncp	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-08 00:56:37.014205+00	2026-07-09 01:04:10.369529+00	o2wf2smxjcbo	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	25	v3r7lsbkl2rr	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-04 02:18:43.567347+00	2026-07-10 04:43:25.528588+00	dc2bfnmsgtsm	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	28	2pygvmuktjsm	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-10 04:43:25.548278+00	2026-07-10 05:41:27.638488+00	v3r7lsbkl2rr	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	29	plivd4ujw7n5	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-10 05:41:27.649397+00	2026-07-10 22:59:09.978497+00	2pygvmuktjsm	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	30	bnlj2reil37k	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-10 22:59:09.996517+00	2026-07-11 00:11:51.022388+00	plivd4ujw7n5	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	31	sfphcpxwqllb	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-11 00:11:51.030593+00	2026-07-11 01:10:07.684398+00	bnlj2reil37k	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	32	wkzxfrpvfuff	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-11 01:10:07.69069+00	2026-07-11 02:23:51.014894+00	sfphcpxwqllb	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	17	brtwsowhkudp	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-02 03:00:22.580998+00	2026-07-13 22:30:49.220704+00	\N	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	35	yexrbxwll4f3	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-13 22:30:49.243188+00	2026-07-14 00:04:16.821392+00	brtwsowhkudp	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	36	5k7fpoxnhwiu	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-14 00:04:16.827134+00	2026-07-14 03:28:19.046724+00	yexrbxwll4f3	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	27	cx7ans42fcx4	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-09 01:04:10.387611+00	2026-07-14 22:55:34.199862+00	wf5mpwezfncp	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	34	kule2butftil	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-13 02:51:59.973811+00	2026-07-15 02:25:49.1827+00	\N	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	37	4kafdkogrxwo	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-14 03:28:19.064915+00	2026-07-15 04:53:54.538413+00	5k7fpoxnhwiu	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	40	3ggpaqiyuciw	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-15 04:53:54.553924+00	2026-07-15 06:16:53.545874+00	4kafdkogrxwo	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	33	ifnytmp6ghqi	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-11 02:23:51.023502+00	2026-07-17 01:18:32.751354+00	wkzxfrpvfuff	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	42	dpr5uuv7vvjp	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-17 01:18:32.770357+00	2026-07-17 04:38:07.10383+00	ifnytmp6ghqi	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	43	pjjrjazl3b3o	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-17 04:38:07.114685+00	2026-07-17 05:36:15.106663+00	dpr5uuv7vvjp	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	44	3s3lcxkunfji	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-17 05:36:15.113021+00	2026-07-17 20:57:33.782454+00	pjjrjazl3b3o	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	45	cfnmaml2aksj	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-17 20:57:33.799857+00	2026-07-17 22:10:55.264269+00	3s3lcxkunfji	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	46	6dhuoxjzaghl	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-17 22:10:55.270552+00	2026-07-18 00:20:54.129899+00	cfnmaml2aksj	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	47	p2nxz2bsilzr	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-18 00:20:54.143594+00	2026-07-18 01:43:31.297379+00	6dhuoxjzaghl	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	48	bckgwip2foum	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-18 01:43:31.306998+00	2026-07-18 03:33:27.371058+00	p2nxz2bsilzr	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	38	uvf237lnafcr	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-14 22:55:34.218077+00	2026-07-18 03:53:53.562046+00	cx7ans42fcx4	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	50	ru2h5l2pxmfg	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-18 03:53:53.567458+00	2026-07-20 00:46:27.99547+00	uvf237lnafcr	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	39	qdnwd6kkvips	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-15 02:25:49.197543+00	2026-07-20 01:38:04.788618+00	kule2butftil	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	51	idoza5v5x5cq	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-20 00:46:28.01572+00	2026-07-21 00:16:05.546841+00	ru2h5l2pxmfg	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	41	7suq3adqi763	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-15 06:16:53.556048+00	2026-07-21 01:03:58.948593+00	3ggpaqiyuciw	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	54	th3h4exwc22v	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-21 01:03:58.953446+00	2026-07-21 02:43:55.791192+00	7suq3adqi763	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	52	tsujgfyjgsv6	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-20 01:38:04.793235+00	2026-07-21 03:39:20.445501+00	qdnwd6kkvips	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	55	3uh6mrzbyxu3	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-21 02:43:55.798658+00	2026-07-21 04:24:59.142822+00	th3h4exwc22v	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	57	gp5p3tjpgyrm	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-21 04:24:59.15346+00	2026-07-21 05:23:11.362017+00	3uh6mrzbyxu3	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	58	7ww6ik6sfkri	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-21 05:23:11.367374+00	2026-07-21 07:18:34.948515+00	gp5p3tjpgyrm	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	53	3mdj46irlxod	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-21 00:16:05.570641+00	2026-07-21 23:04:48.564968+00	idoza5v5x5cq	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	49	ra2bt2s4vwt5	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-18 03:33:27.37901+00	2026-07-24 03:13:54.777441+00	bckgwip2foum	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	61	u2o6xjmxry2x	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-24 03:13:54.798084+00	2026-07-24 04:12:11.825233+00	ra2bt2s4vwt5	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	62	3gwkx2ddp36h	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-24 04:12:11.832916+00	2026-07-24 06:03:29.658912+00	u2o6xjmxry2x	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	63	o6ze7cohu7lw	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-24 06:03:29.664305+00	2026-07-24 22:52:35.42168+00	3gwkx2ddp36h	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	136	ovjj2ien3apn	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-19 23:15:07.444297+00	2026-08-20 00:17:22.361003+00	z3ifo4auvhlz	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	65	uja2krncnmem	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-25 00:39:36.158487+00	2026-07-25 02:44:46.485408+00	aiqrczu4v6rc	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	68	dxtzw7wvaafh	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-27 05:08:45.071312+00	2026-07-28 01:32:33.493489+00	y3hwkadwxn4s	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	67	kadbtbtz24v2	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-27 00:44:54.860691+00	2026-07-28 02:51:13.183875+00	imf6fihj4ypa	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	71	charcujon7by	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-28 22:40:27.84472+00	2026-07-29 00:04:22.080737+00	f5fwybotur7q	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	69	xvdjfdmulqid	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-28 01:32:33.510986+00	2026-07-29 00:45:24.650297+00	dxtzw7wvaafh	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	72	pbg7g4qherti	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-29 00:04:22.086561+00	2026-07-29 01:02:47.861696+00	charcujon7by	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	70	v2kxdtludr57	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-28 02:51:13.188888+00	2026-07-29 03:08:46.612804+00	kadbtbtz24v2	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	74	uddbjnmdyqoi	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-29 01:02:47.869174+00	2026-07-29 04:38:50.388393+00	pbg7g4qherti	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	76	ua7sxxqny5kk	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-29 04:38:50.401429+00	2026-07-29 05:37:00.291963+00	uddbjnmdyqoi	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	73	naqtehcxs3ey	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-29 00:45:24.657958+00	2026-07-30 00:10:43.066988+00	xvdjfdmulqid	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	77	xnjk4imieuqg	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-29 05:37:00.297875+00	2026-07-30 01:26:33.933732+00	ua7sxxqny5kk	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	75	5f55afosggap	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-29 03:08:46.617609+00	2026-07-30 02:23:45.020826+00	v2kxdtludr57	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	79	d6dykbmoytoq	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-30 01:26:33.939515+00	2026-07-30 03:17:51.016901+00	xnjk4imieuqg	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	81	45d2s7wkiem3	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-30 03:17:51.021717+00	2026-07-30 04:16:04.972692+00	d6dykbmoytoq	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	80	x5cddws7rbyu	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-30 02:23:45.030083+00	2026-07-30 22:38:30.256716+00	5f55afosggap	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	78	msdmvdxhb43s	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-30 00:10:43.081044+00	2026-07-30 22:55:31.317564+00	naqtehcxs3ey	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	84	nupjjet7ijgz	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-30 22:55:31.321442+00	2026-07-30 23:53:57.358789+00	msdmvdxhb43s	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	82	ygn2xdbbovx2	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-30 04:16:04.977452+00	2026-08-01 05:55:25.659436+00	45d2s7wkiem3	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	86	d2rwphvj334o	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-01 05:55:25.669261+00	2026-08-01 07:08:18.801421+00	ygn2xdbbovx2	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	87	5s4wcsfppwpx	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-01 07:08:18.823132+00	2026-08-01 08:13:01.6532+00	d2rwphvj334o	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	88	nx4azp7v53ux	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-01 08:13:01.658747+00	2026-08-02 04:22:26.819074+00	5s4wcsfppwpx	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	89	aozo5roe3nqa	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-02 04:22:26.841733+00	2026-08-02 05:20:35.929147+00	nx4azp7v53ux	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	90	2vhdyk4nx7l7	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-02 05:20:35.934312+00	2026-08-02 06:18:56.541151+00	aozo5roe3nqa	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	91	3mhvocpae3ju	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-02 06:18:56.547039+00	2026-08-03 23:19:29.007762+00	2vhdyk4nx7l7	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	92	2zk3msmpsnpx	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-03 23:19:29.021302+00	2026-08-04 00:17:49.549608+00	3mhvocpae3ju	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	85	e2mfyw2apwdo	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-07-30 23:53:57.365901+00	2026-08-04 00:26:40.865458+00	nupjjet7ijgz	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	95	jqru2g5zpsom	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	f	2026-08-04 00:29:57.894762+00	2026-08-04 00:29:57.894762+00	\N	71c5c60e-0405-4c23-8fed-f3fd8694849d
00000000-0000-0000-0000-000000000000	93	una4yn3kpyex	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-04 00:17:49.559083+00	2026-08-04 01:16:05.987222+00	2zk3msmpsnpx	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	96	d54ufrk3r3sv	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-04 01:16:05.99836+00	2026-08-04 02:30:37.388256+00	una4yn3kpyex	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	83	awoonk3pdpfk	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-07-30 22:38:30.27104+00	2026-08-04 02:31:27.076007+00	x5cddws7rbyu	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	98	vh63r3gzkfvl	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-04 02:31:27.081898+00	2026-08-04 03:33:17.312624+00	awoonk3pdpfk	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	97	t5h4peof6fq4	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-04 02:30:37.392456+00	2026-08-04 04:49:19.122455+00	d54ufrk3r3sv	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	66	k6dphqvbudsh	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-07-25 02:44:46.491608+00	2026-08-05 00:48:38.346764+00	uja2krncnmem	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	101	yoijozwdn67u	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 00:48:38.363435+00	2026-08-05 01:46:40.126271+00	k6dphqvbudsh	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	102	u6oxudtxf6r6	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 01:46:40.130643+00	2026-08-05 02:44:51.744132+00	yoijozwdn67u	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	103	2usp7qtfmg3u	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 02:44:51.750038+00	2026-08-05 04:48:23.713516+00	u6oxudtxf6r6	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	104	7vnr77i4qgby	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 04:48:23.717866+00	2026-08-05 05:46:33.525988+00	2usp7qtfmg3u	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	105	6tizvcdel3vf	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 05:46:33.532964+00	2026-08-05 22:53:35.878231+00	7vnr77i4qgby	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	106	3sjsfyxg2mpa	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-05 22:53:35.891394+00	2026-08-06 21:47:45.167188+00	6tizvcdel3vf	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	107	6c42bdq27tlt	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-06 21:47:45.188499+00	2026-08-07 00:38:49.521586+00	3sjsfyxg2mpa	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	108	5tzjl2pxmlas	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 00:38:49.528228+00	2026-08-07 02:34:09.860687+00	6c42bdq27tlt	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	109	nrrafu36bcn6	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 02:34:09.865096+00	2026-08-07 04:05:12.614896+00	5tzjl2pxmlas	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	110	yhahfsykeyah	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 04:05:12.621305+00	2026-08-07 05:24:35.706243+00	nrrafu36bcn6	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	111	laj5cu6zbzbc	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 05:24:35.715721+00	2026-08-07 22:16:59.841524+00	yhahfsykeyah	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	112	tutejgih5xt3	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 22:16:59.851418+00	2026-08-07 23:52:06.495463+00	laj5cu6zbzbc	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	94	o32guhjpd3ir	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-04 00:26:40.8696+00	2026-08-09 23:58:51.04547+00	e2mfyw2apwdo	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	99	jjtti4nze5fo	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-04 03:33:17.321857+00	2026-08-10 02:05:27.036078+00	vh63r3gzkfvl	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	100	nfbkmtaj6etn	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-04 04:49:19.13611+00	2026-08-10 03:31:57.11687+00	t5h4peof6fq4	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	114	r6dchkrj6iu4	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-09 23:58:51.057139+00	2026-08-13 00:11:44.251841+00	o32guhjpd3ir	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	113	h5jnwkxk5prj	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-07 23:52:06.500751+00	2026-08-18 23:06:49.143615+00	tutejgih5xt3	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	134	z3ifo4auvhlz	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-19 21:52:25.952782+00	2026-08-19 23:15:07.437775+00	om7bxzdcmhhk	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	115	zzotnkddibss	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-10 02:05:27.053387+00	2026-08-10 03:15:48.045979+00	jjtti4nze5fo	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	137	ee33vsmfubei	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-20 00:17:22.367474+00	2026-08-20 07:44:39.419989+00	ovjj2ien3apn	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	116	smhhvjhgqljv	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-10 03:15:48.054944+00	2026-08-11 01:19:19.716563+00	zzotnkddibss	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	138	ckuivfyhdyzf	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-20 07:44:39.441857+00	2026-08-20 22:32:48.468197+00	ee33vsmfubei	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	117	6kqes2lkw3d7	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-10 03:31:57.121093+00	2026-08-12 22:15:10.307916+00	nfbkmtaj6etn	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	119	uspit3ydmc7v	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-12 22:15:10.337805+00	2026-08-12 23:49:40.108726+00	6kqes2lkw3d7	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	127	cfeaoqwslcms	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-17 23:09:37.975055+00	2026-08-23 04:37:33.634382+00	od4zyq226ssg	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	139	xxw5r3anizkq	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-20 22:32:48.481301+00	2026-08-25 00:07:10.015271+00	ckuivfyhdyzf	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	120	eyvtuga4tfhb	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-12 23:49:40.114862+00	2026-08-13 00:57:11.385581+00	uspit3ydmc7v	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	121	zpbhxqdotmr5	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-13 00:11:44.256311+00	2026-08-13 04:13:31.196981+00	r6dchkrj6iu4	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	141	synbuvlbn2br	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-25 00:07:10.03836+00	2026-08-25 01:27:08.638589+00	xxw5r3anizkq	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	123	gwpe2q7wntgi	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-13 04:13:31.207431+00	2026-08-13 22:26:09.946174+00	zpbhxqdotmr5	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	124	5tcdapy3jmbc	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-13 22:26:09.966991+00	2026-08-13 23:24:11.151976+00	gwpe2q7wntgi	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	142	3zqpsaqdldvu	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-25 01:27:08.65321+00	2026-08-25 03:20:28.433161+00	synbuvlbn2br	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	125	772e2ohqvco6	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-13 23:24:11.160553+00	2026-08-17 00:48:53.526897+00	5tcdapy3jmbc	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	126	od4zyq226ssg	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-17 00:48:53.544096+00	2026-08-17 23:09:37.958623+00	772e2ohqvco6	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	122	7ji4gh5qnqlc	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-13 00:57:11.395113+00	2026-08-18 03:57:53.003128+00	eyvtuga4tfhb	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	128	kb4gx4dzfqvi	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-18 03:57:53.012286+00	2026-08-26 00:21:51.002219+00	7ji4gh5qnqlc	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	129	35er5zmmhdhj	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-18 23:06:49.157386+00	2026-08-19 01:00:47.054056+00	h5jnwkxk5prj	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	130	mgwcrvban6hp	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-19 01:00:47.061783+00	2026-08-19 02:16:41.515982+00	35er5zmmhdhj	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	135	ltmntf2uuxkw	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-19 22:53:06.24125+00	2026-08-26 01:01:47.764876+00	daw46cburnyo	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	118	z6dg2ggc7rlc	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-11 01:19:19.73686+00	2026-08-19 02:17:21.080848+00	smhhvjhgqljv	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	145	pxtpse2couni	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	f	2026-08-26 01:01:47.770139+00	2026-08-26 01:01:47.770139+00	ltmntf2uuxkw	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	131	c5ckk4ytmw4t	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-19 02:16:41.525121+00	2026-08-19 04:23:08.24332+00	mgwcrvban6hp	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	144	xcgvzav6m632	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-26 00:21:51.027574+00	2026-08-26 01:20:20.413607+00	kb4gx4dzfqvi	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	133	om7bxzdcmhhk	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-19 04:23:08.261035+00	2026-08-19 21:52:25.932307+00	c5ckk4ytmw4t	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	132	daw46cburnyo	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	t	2026-08-19 02:17:21.08192+00	2026-08-19 22:53:06.2361+00	z6dg2ggc7rlc	1c3181be-21f7-4eae-831b-e6891e308bda
00000000-0000-0000-0000-000000000000	146	efrsi6j6dxct	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-26 01:20:20.419203+00	2026-08-26 04:03:29.096654+00	xcgvzav6m632	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	147	fkyrmmmzpwvg	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	f	2026-08-26 04:03:29.111149+00	2026-08-26 04:03:29.111149+00	efrsi6j6dxct	663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d
00000000-0000-0000-0000-000000000000	140	t23w6pv4xmgm	2050fcad-2f14-4ee2-ab6e-570abce647a3	t	2026-08-23 04:37:33.645253+00	2026-08-26 04:53:41.984809+00	cfeaoqwslcms	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	148	dhm7cjk23zqq	2050fcad-2f14-4ee2-ab6e-570abce647a3	f	2026-08-26 04:53:41.99357+00	2026-08-26 04:53:41.99357+00	t23w6pv4xmgm	a288011b-11b3-4bf2-93e9-1dd9e49e659e
00000000-0000-0000-0000-000000000000	143	kl7an6ay7vy2	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-25 03:20:28.439191+00	2026-08-27 00:02:47.924411+00	3zqpsaqdldvu	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	149	cyrbxolp6ox4	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-27 00:02:47.942357+00	2026-08-27 01:39:19.22285+00	kl7an6ay7vy2	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	150	kp4zfgfr65ql	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-27 01:39:19.229388+00	2026-08-27 02:39:44.794757+00	cyrbxolp6ox4	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	151	55q7nd73pp74	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-27 02:39:44.80168+00	2026-08-27 21:49:52.135253+00	kp4zfgfr65ql	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	152	4g4mxijojffu	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-27 21:49:52.154034+00	2026-08-27 23:37:21.651889+00	55q7nd73pp74	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	153	7virix3iiy75	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-27 23:37:21.663293+00	2026-08-28 03:28:45.328535+00	4g4mxijojffu	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	154	x2w64uqmjzwt	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	t	2026-08-28 03:28:45.343506+00	2026-08-28 05:03:52.73993+00	7virix3iiy75	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
00000000-0000-0000-0000-000000000000	155	a4rcraklxwji	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	f	2026-08-28 05:03:52.744319+00	2026-08-28 05:03:52.744319+00	x2w64uqmjzwt	ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
20260625000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
0eaa571d-f420-4ad9-9c5d-eac983927d41	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	2026-07-02 00:09:54.236976+00	2026-07-02 00:09:54.236976+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	125.239.26.180	\N	\N	\N	\N	\N
a0c8afb9-5002-4129-a144-10d64df89031	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	2026-07-02 02:58:15.628309+00	2026-07-02 02:58:15.628309+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	125.239.26.180	\N	\N	\N	\N	\N
2cf8b78f-75df-4b81-9a47-fdf6032f70a0	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	2026-07-02 03:04:12.95179+00	2026-07-02 03:04:12.95179+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	125.239.26.180	\N	\N	\N	\N	\N
1c3181be-21f7-4eae-831b-e6891e308bda	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	2026-07-13 02:51:59.928344+00	2026-08-26 01:01:47.782452+00	\N	aal1	\N	2026-08-26 01:01:47.782334	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36	222.152.73.179	\N	\N	\N	\N	\N
71c5c60e-0405-4c23-8fed-f3fd8694849d	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	2026-08-04 00:29:57.882925+00	2026-08-04 00:29:57.882925+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	222.152.85.156	\N	\N	\N	\N	\N
663a9c9f-53c1-4ff9-ab33-c3e6241ccd1d	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	2026-07-02 03:00:22.577473+00	2026-08-26 04:03:29.130206+00	\N	aal1	\N	2026-08-26 04:03:29.130092	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36	222.152.85.156	\N	\N	\N	\N	\N
a288011b-11b3-4bf2-93e9-1dd9e49e659e	2050fcad-2f14-4ee2-ab6e-570abce647a3	2026-07-02 04:53:53.293904+00	2026-08-26 04:53:42.009357+00	\N	aal1	\N	2026-08-26 04:53:42.0092	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36	125.239.72.8	\N	\N	\N	\N	\N
ac7caf59-7e5a-42af-9a16-5b2f1c3d0ff3	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	2026-07-03 00:29:05.428627+00	2026-08-28 05:03:52.758771+00	\N	aal1	\N	2026-08-28 05:03:52.758657	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36	125.239.72.8	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	cf9e07b5-34a4-4fe8-88f9-0a6818df681d	authenticated	authenticated	gabrielle@jamies.co.nz	$2a$10$UIDk3soNtdrUDbSu0C2mm.pt3SK60aEmAJgDKFrO3f1FYnN75c94O	2026-07-01 04:47:51.41032+00	\N		\N		\N			\N	2026-08-04 00:29:57.882805+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-07-01 04:47:51.395529+00	2026-08-28 05:03:52.746817+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	authenticated	authenticated	rachel@jamies.co.nz	$2a$10$6JdTepg1r2fQAT90/ocPNu5StslS/nWooKeRnMsIauMLnOIRMUT16	2026-07-02 00:05:22.533188+00	\N		\N		\N			\N	2026-07-13 02:51:59.928238+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-07-02 00:05:22.503484+00	2026-08-26 01:01:47.772601+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2050fcad-2f14-4ee2-ab6e-570abce647a3	authenticated	authenticated	paula@jamies.co.nz	$2a$10$KCwIzjU0xT4DuLsLsGQoluarxTqOTJ1ngpJBQA5FHvw39t/ntd4wq	2026-07-01 04:46:22.484827+00	\N		\N		\N			\N	2026-07-02 04:53:53.293057+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-07-01 04:46:22.480465+00	2026-08-26 04:53:41.996278+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e6c0d0c1-b88d-465f-be58-63a565dedef3	authenticated	authenticated	gabriellejl@gmail.com	$2a$10$PWclgOsUtR//G9pAdC6Qb.tPFQZ3.wXMGnUC7Sn8r1cHFBPyzWfc6	2026-07-01 21:55:42.192436+00	2026-07-01 21:20:41.85118+00		\N		\N			\N	2026-07-01 23:36:12.164667+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-07-01 21:20:41.816056+00	2026-07-01 23:36:34.819022+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: billing_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_runs (id, run_date, user_name, retailer_ids, packet_ids, status, created) FROM stdin;
mp4wn6pzbejwc	14 May 2026	gabby	1,2	moz6wt6nu4oza,moz6zvc6tdyci,moz77ix06i9sv,moz7igl8hq1en,moz7kzy24sk6h,moz7n9sundg6n,moz7o707cxwkh	completed	14 May 2026
mp4wntyhuqscm	14 May 2026	paula	1,2	moz6wt6nu4oza,moz6zvc6tdyci,moz71boglfxhy,moz72syh1uq4q,moz77ix06i9sv,moz7brblz5m7t,moz7d2eyt841f,moz7gnp4qtcph,moz7hppskqcsd,moz7kzy24sk6h,moz7lu6zjfg9a,moz7n9sundg6n,moz7o707cxwkh	completed	14 May 2026
mpj359lsv32ef	24 May 2026	paula	1,2	mp4wp5h76km34,mp4wpr9d6bvj1,mpaqdd6r0ugai,mpj1rdvb2aaz5,mpj1vfbpb3im9,mpj1xxhfmalm2,mpj22zvnejwt3,mpj256tgtwlqb,mpj26unn5a747,mpj2850b8oj01	completed	24 May 2026
mpuh6jimbyhd0	01 Jun 2026	paula	1,2	mpn7m1rcl6fpy,mprluky6094oh,mpt1gd57dbvz7,mpt26ajgnvx4q,mpugk0xnwdp83,mpugm9vpaqlad,mpugmys012a6x,mpugp2pbqjpfw,mpugrx2kzmb16,mpugsr1curnij	completed	01 Jun 2026
mpuhlcg3ripdw	01 Jun 2026	gabby	1,2	mpj2aby40he8w,mpqbei6pycqa3,mpqezio663wvh,mpqfxtmmxda0p,mpqgqk087ln3z,mpqhamsm7qisj,mprluky6094oh,mpt1gd57dbvz7,mpt26ajgnvx4q,mpt508j5zmqoz,mpugk0xnwdp83	completed	01 Jun 2026
mr1g8ef0jsmij	01 Jul 2026	paula	1	mq4luv5dh8ef0,mq4lwahr7u5nx,mq4qlnop9rbs5,mq4qmjvhqi0xj,mq4qskulr1hmy,mq4qvld2seu0r,mq8nb4mqfgqwt,mqopjc2dd1alz,mqoqfzn9ar9dn,mqosdjmmli3cj,mqosel7fq4gav,mqrcfrw7u2qg9,mqzyf101brrrs,mqzyglxtan1om,mqzyhpxdrmdrq,mqzyk1w155bzp,mqzyl9o0opun2	completed	01 Jul 2026
mr1gfc3l3kppg	01 Jul 2026	paula	2	mq4qkjogkwsjc,mq4qr8ekal6k7,mq4qwp9mnhj91,mq4qyzhs0tsts,mqbpegq676dmi,mqeqfilhk1jgt,mqk2mbiffsn6a,mqogj7o7j90h4,mqsq37f0lk58s,mqx3v5c1xcm8y	completed	01 Jul 2026
mr1guk6q3s1in	01 Jul 2026	gabby	1	mq4luv5dh8ef0,mq4lwahr7u5nx,mq4qlnop9rbs5,mq4qmjvhqi0xj,mq4qskulr1hmy,mq4qui5ys3g91,mq4qvld2seu0r,mq4r0sciq4w36,mq8nb4mqfgqwt,mqopjc2dd1alz,mqoqfzn9ar9dn,mqosdjmmli3cj,mqosel7fq4gav,mqosfgiequ4bc,mqrcfrw7u2qg9,mqzyf101brrrs,mqzyglxtan1om,mqzyhpxdrmdrq,mqzyk1w155bzp,mqzyl9o0opun2	completed	01 Jul 2026
mr1gv2ugkfv0j	01 Jul 2026	paula	1	mq4luv5dh8ef0,mq4lwahr7u5nx,mq4qlnop9rbs5,mq4qmjvhqi0xj,mq4qskulr1hmy,mq4qvld2seu0r,mq8nb4mqfgqwt,mqopjc2dd1alz,mqoqfzn9ar9dn,mqosdjmmli3cj,mqosel7fq4gav,mqrcfrw7u2qg9,mqzyf101brrrs,mqzyglxtan1om,mqzyhpxdrmdrq,mqzyk1w155bzp,mqzyl9o0opun2	completed	01 Jul 2026
mr1gwwcglx9xj	01 Jul 2026	gabby	2	mq4qkjogkwsjc,mq4qr8ekal6k7,mq4qwp9mnhj91,mq4qyzhs0tsts,mqbpe045n27xc,mqbpegq676dmi,mqeqfilhk1jgt,mqk2mbiffsn6a,mqogj7o7j90h4,mqsq37f0lk58s,mqwzmp2xu0gi3,mqx3v5c1xcm8y	completed	01 Jul 2026
mr1gxaq8ps22o	01 Jul 2026	paula	2	mq4qkjogkwsjc,mq4qr8ekal6k7,mq4qwp9mnhj91,mq4qyzhs0tsts,mqbpegq676dmi,mqeqfilhk1jgt,mqk2mbiffsn6a,mqogj7o7j90h4,mqsq37f0lk58s,mqx3v5c1xcm8y	completed	01 Jul 2026
msbf85nykdzqp	02 Aug 2026	gabby	2	mr4dmrr7hhh3q,mr4ecwp52kgcm,mr4hszniyal7s,mr5mqhl1i7718,mrct12e2hgcp0,mrfneqd55tfgi,mroh3gvifseup,mrsiczyyhp1lq,mrv9hub1txk5s,mrv9mqcb9xd7m,mrydatw29mt9e,ms3zhksmeegro,ms844mesr521t	completed	02 Aug 2026
msbf8qwrz2ibx	02 Aug 2026	gabby	1	mr3169xk3qvg3,mr3175syumw0c,mr474ryz3l32m,mr4dl9nmf960t,mr5qhkl68th39,mr5qied778ml9,mrbddb4v049b1,mrbdfkxqvizdj,mregb5wntofgd,mrfoznnh65taa,mrfqrav7z307y,mrl95pe2ahahq,mrog7fpk0272s,mroi33om7hpkl,mrpmh0645mpaw,mrsi9qebtaqp4,mrydbm91q8m80,mryennigsa21h,ms6riciinmciv,ms8785faz8btf	completed	02 Aug 2026
msbf940leojw8	02 Aug 2026	gabby	6	mrzn73i8c3xh6	completed	02 Aug 2026
msbf9ojfu5uro	02 Aug 2026	paula	1	mr3169xk3qvg3,mr3175syumw0c,mr474ryz3l32m,mr4dl9nmf960t,mrbddb4v049b1,mrbdfkxqvizdj,mregb5wntofgd,mrl95pe2ahahq,mroi33om7hpkl,mrsi9qebtaqp4,ms6riciinmciv,ms8785faz8btf	completed	02 Aug 2026
msbfa58a8lzi5	02 Aug 2026	paula	2	mr4dmrr7hhh3q,mr5mqhl1i7718,mrct12e2hgcp0,mrfneqd55tfgi,mroh3gvifseup,mrsiczyyhp1lq,mrv9hub1txk5s,mrv9mqcb9xd7m,mrydatw29mt9e,ms3zhksmeegro,ms844mesr521t	completed	02 Aug 2026
msbfail0nulwq	02 Aug 2026	paula	6	mrzn73i8c3xh6	completed	02 Aug 2026
mse1wzidqt7ks	04 Aug 2026	paula	3	mqojusc7umv9m,mqsq1qgua6gne	completed	04 Aug 2026
mse1xyec9qf7x	04 Aug 2026	paula	3	mr2x674vdn0aa,mr2x6wedew0j4,mrfm1z0pba2hm,mrfm2sgh5csy8,mrfm3otmkt3rh,mrl94e2adhowx,mrptbw1lcmdhk,mrptcvn63dult,mrsib0jva7s4x,mrsibtkon1wfp,mrtwv80kej5fm,mryjbmcst7rp6,mryjcb8k0ksbz,mrzrnvet0hxx6,ms3zfs2vaz0dx,ms3ziy4esct4s,ms5dc9ls5i30n,ms5dd6kp6o6k0,ms6rdf7hx2vmk,ms6rfjq9s7m7p,ms6rh6wp41xzk	completed	04 Aug 2026
\.


--
-- Data for Name: billing_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_statuses (id, name, show_in_dashboard, show_in_reports) FROM stdin;
1	New	t	t
2	Hold from Billing	t	t
3	Billed	t	t
4	Archived	f	f
\.


--
-- Data for Name: id_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.id_reports (id, created_at, updated_at, date_of_issue, identification, description, measurements, photo_path, report_number) FROM stdin;
e0e09b5e-dfb7-47bf-b18f-17d2c466e5b4	2026-06-03 00:41:39.480329	2026-06-03 00:41:39.480329	2026-06-02	Amethyst and 10k Gold	Amethyst pendant in 10k Gold on a plated chain.	Amethyst 15 x 13mm (Oval)	02-Campbell.jpg	CERT-20260603-822
b4c4283b-22dc-46d1-9374-5f5f149a0cf1	2026-06-03 00:38:21.747704	2026-06-03 01:06:01.622	2026-06-02	18k Gold	18k yellow and white gold diamond cluster ring\n	Width of band 2.05 widening to 5.23mm.\n	02-Campbell.jpg	CERT-20260603-909
5ce63362-9d2a-4261-bacf-dca8bdb8b5d3	2026-06-03 03:30:51.424163	2026-06-03 03:30:51.424163	2026-06-03	Unset gemstone	Oval peridot	6.47 x 5.08mm	03-Kilgour peridot.jpg	CERT-20260603-183
14ed8add-4186-4fa7-acf7-59324a3b2b9a	2026-06-03 03:31:56.254202	2026-06-03 03:31:56.254202	2026-06-03	Unset gemstone	Oval peridot	6.47 x 5.08mm	03-Kilgour peridot.jpg	CERT-20260603-826
cfd1a53f-3084-4a70-b675-819131717173	2026-06-03 03:38:36.30508	2026-06-03 03:38:36.30508	2026-06-03	Unset gemstone	Rectangular, step-cut zircon, .79ct	4.1 x 6.09mm 	03-Kilgour zircon.jpg	CERT-20260603-576
7e6d4c5a-7667-487f-bdbb-bc035bc08dea	2026-06-03 03:41:13.384143	2026-06-03 03:41:13.384143	2026-06-03	Unset gemstone	Round almandine-type garnet.  .63ct	5mm round.  Dark red	03-Kilgour Garnet 2.jpg	CERT-20260603-836
6be00d72-d03c-498e-9abc-e712c7f9dcc0	2026-06-03 03:44:35.898058	2026-06-03 03:44:35.898058	2026-06-03	Unset gemstone	Oval cabochon-cut solid opal   1.47ct;   grey background;  blue-green iridescence	18.86 x 7.34mm	03 Kilgour opal 1.jpg	CERT-20260603-032
894fbb02-ad27-4a1d-8cf0-f536059e96dc	2026-06-03 03:47:16.147417	2026-06-03 03:47:16.147417	2026-06-03	Unset gemstone	Oval boulder opal; blue opalescent vein through sandstone potch.  5.04ct	14.33 x 8.45mm	03-Kilgour opal 2.jpg	CERT-20260603-650
6b894d97-bbd2-467e-bafb-bb1a58ad4c53	2026-06-03 03:48:58.478519	2026-06-03 03:48:58.478519	2026-06-03	Unset gemstone	Oval peridot; green; .83ct	6.47 x 5.08mm	03-Kilgour peridot.jpg	CERT-20260603-747
78dc6091-eec3-43fe-a22c-36c708d63aef	2026-06-04 22:19:49.116705	2026-06-04 22:19:49.116705	2026-06-05	Gem Test report - delete	test	fesr	04-Smith 1a.jpg	CERT-20260605-538
46fe18d4-b9b2-4c8f-a45f-cc637f0836cc	2026-06-17 23:21:17.511026	2026-06-17 23:21:17.511026	2026-06-18	Unset sapphire	 Oval sapphire   4.08ct.\nColour: blue. GIA vB with greyish overtones. Variation in colour through the stone - very light to strong blue.\nClarity: moderately to heavily included.	10.93 x 7.37 x 5.11mm	17 Mackay VDW.jpg	CERT-20260618-213
a5643434-b3f9-4af2-bcb3-6c5291990ff1	2026-06-21 23:15:46.793838	2026-06-21 23:15:46.793838	2026-06-16	Pink Tourmaline	Unset gemstone trillion cut.	7.32 x 7.28 x 3.94mm	16-Worthington 01.jpg	CERT-20260622-810
d188654a-e684-4623-b55d-f96c3d335483	2026-06-21 23:19:29.497841	2026-06-21 23:19:29.497841	2026-06-16	Pink Tourmaline	Unset gemstone trillion cut.	6.96 x 6.95 x 3.86mm	16-Worthington 02.jpg	CERT-20260622-485
8a753ddd-3571-4839-b9db-4bc2af9fe108	2026-06-21 23:23:07.396021	2026-06-21 23:23:07.396021	2026-06-22	Pink Sapphire	Unset gemstone, pear cut.	6.27 x 4.92 x 2.7mm	16-Worthington 03.jpg	CERT-20260622-660
bd1e45ff-7303-4cd9-a2ea-c4ee4dea94f0	2026-06-21 23:27:25.040606	2026-06-21 23:27:25.040606	2026-06-22	Blue Sapphire	Unset gemstone, oval cut.	6.08 x 5.07 x 4.43mm	16-Worthington 04.jpg	CERT-20260622-293
71adcaa8-27fc-42af-b947-d2d40a71cae3	2026-06-21 23:33:26.224264	2026-06-21 23:33:26.224264	2026-06-22	Blue Sapphire	Unset gemstone, square cut.	6.12 x 5.95 x 4.01mm	16-Worthington 05.jpg	CERT-20260622-907
68eb7b14-5775-4f22-9e5a-191d40dfcc6e	2026-06-21 23:39:34.930647	2026-06-21 23:39:34.930647	2026-06-22	White Sapphire	Unset gemstone, oval cut.	3.99 x 3.05 x 2.25mm	16-Worthington 06.jpg	CERT-20260622-241
6b67e451-c701-4ee2-a07b-3c5c0ef5dacc	2026-06-21 23:43:15.257862	2026-06-21 23:43:15.257862	2026-06-22	White Sapphire	Unset gemstone, oval cut.	3.64 x 3.15 x 2.0mm	16-Worthington 07.jpg	CERT-20260622-176
921672d9-54c5-4b4a-954c-23d9a0490d30	2026-07-29 05:44:38.945374	2026-07-29 05:44:38.945374	2026-07-01	Sapphire (example cert)	Natural Blue Sapphire in oval, brilliant cut.	2.92mm x 2.25mm (0.78ct)	Sapphire.jpeg	CERT-20260729-333
d4250fdb-06c7-4aa3-bfe8-6088169e28a8	2026-08-10 00:21:14.875787	2026-08-10 00:21:14.875787	2026-08-10	Unset gem-stone.  Tourmaline	Emerald-cut, medium dark, blue Green Tourmaline.  GIA b/G;  eye clean (very small abrasions on several of the pavilion facets.  Brazilian origin.\n$4325.00\n	14.11 x 10.95 x 7.15	08-JD stock tourmaline.jpg	CERT-20260810-069
89fb012c-c1f1-4c26-a1d6-319e1c8a7624	2026-08-10 00:22:42.919194	2026-08-10 00:22:42.919194	2026-08-10	Unset gem-stone.  Tourmaline	Emerald-cut, medium dark, blue Green Tourmaline.  GIA b/G;  eye clean (very small abrasions on several of the pavilion facets).  Brazilian origin.  Weight 8.93ct.\n$4325.00\n	14.11 x 10.95 x 7.15	08-JD stock tourmaline.jpg	CERT-20260810-968
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (name, display_order) FROM stdin;
Earrings	4
Pearls	2
Pendant	3
Ring	1
Gemstone	8
Brooch	9
Other	10
Bracelet	5
Chain	6
Necklace	7
\.


--
-- Data for Name: job_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_types (id, name, cost, display_order) FROM stdin;
1	Standard - Stoneset	70.00	1
2	Standard - Plain Unset	50.00	2
4	Brief/Inventory - Stoneset	50.00	6
5	Brief/Inventory - Plain Unset	40.00	7
6	Pearl Threading	0.00	3
7	ID Only - Metal OR Gem	25.00	9
8	ID Only - Metal AND Gem	35.00	10
9	Stock Update	25.00	4
10	Customer Update	25.00	5
11	Stock - New	50.00	11
3	Complex (multi-stone/antique etc)	0.00	8
\.


--
-- Data for Name: nj_credit_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nj_credit_notes (id, nj_statement_id, accounting_ref, subtotal, gst, total, issue_date, status, created, source_payment_id) FROM stdin;
\.


--
-- Data for Name: nj_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nj_payments (id, amount, received_date, reference, nj_statement_id, status, created) FROM stdin;
\.


--
-- Data for Name: nj_statement_lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nj_statement_lines (id, statement_id, line_type, tax_invoice_id, credit_note_id, payment_id, sub_customer_name, amount) FROM stdin;
mse1zdeaov4rr	msdw5fe8z6kxj	invoice	ms2iwre899es5	\N	\N	Van de Waters	168.14999999999998
mse1zdxzxvzmj	msdw5fe8z6kxj	invoice	mru4iisy3c4bb	\N	\N	GMW Jewellery	317.65
mse1zehlhhs82	msdw5fe8z6kxj	invoice	mru46zlibgavt	\N	\N	GMW Jewellery	329.15
mse1zezv49wra	msdw5fe8z6kxj	invoice	mrsk4a79g01fs	\N	\N	Van de Waters	64.65
mse1zfg34x1an	msdw5fe8z6kxj	invoice	mrlgnzrvspdio	\N	\N	Van de Waters	92.75
mse1zfyko1bb8	msdw5fe8z6kxj	invoice	mrin425h5pyqy	\N	\N	JDs	248
mse1zghbdi93m	msdw5fe8z6kxj	invoice	mqu2165imtctq	\N	\N	Van de Waters	31.501
mse1zh6gjcams	msdw5fe8z6kxj	invoice	a26cd551-ca62-424a-ab1b-be76654e6e44	\N	\N	Van de Waters	31.501
mse1zashufzz1	msdw5fe8z6kxj	invoice	ms9yq54n96o8z	\N	\N	GMW Jewellery	167.5
mse1zb814sm8c	msdw5fe8z6kxj	invoice	ms6wdjalene6w	\N	\N	Van de Waters	310
mse1zbwjc7003	msdw5fe8z6kxj	invoice	ms5ip3arq84ok	\N	\N	GMW Jewellery	252.5
mse1zcdbxq109	msdw5fe8z6kxj	invoice	ms43xj3bucgtt	\N	\N	JDs	168.14999999999998
mse1zctu62mca	msdw5fe8z6kxj	invoice	ms440u3jnoiee	\N	\N	GMW Jewellery	87.65
\.


--
-- Data for Name: nj_statements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nj_statements (id, period_start, period_end, generated_date, statement_date, subtotal, gst, total, opening_balance, aging_current, aging_30, aging_60, aging_90, accounting_ref, status, created, paid_date) FROM stdin;
msdw5fe8z6kxj	2026-06-22	2026-07-30	2026-08-03	2026-07-31	1973.175652173913	295.9763478260869	2269.1520000000005	0	2206.15	63.002	0	0	\N	final	04 Aug 2026	\N
\.


--
-- Data for Name: packet_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.packet_items (id, packet_id, item, job_type_id, cost, paula_pct, gabrielle_pct) FROM stdin;
moz6wuih8emfh	moz6wt6nu4oza	Ring	1	70.00	20	80
moz6zwqearrjn	moz6zvc6tdyci	Ring	1	70.00	20	80
moz6zx1rbc8ub	moz6zvc6tdyci	Ring	1	70.00	20	80
moz73w7zuvmzh	moz72syh1uq4q	Necklace	6	73.00	100	0
moz74khabbn8a	moz71boglfxhy	Necklace	6	55.00	100	0
moz7bsa23djpu	moz7brblz5m7t	Ring	9	150.00	100	0
moz7d2qly3ym5	moz7d2eyt841f	Ring	1	70.00	100	0
moz7gobi8z5kr	moz7gnp4qtcph	Pendant	10	25.00	100	0
moz7ih6j2s0u6	moz7igl8hq1en	Ring	9	25.00	0	100
moz7l0ijlkq1x	moz7kzy24sk6h	Ring	1	70.00	20	80
moz7lujvdazj8	moz7lu6zjfg9a	Necklace	6	50.00	100	0
moz7na7uauek7	moz7n9sundg6n	Earrings	1	70.00	10	90
moz7o7bk4lf7u	moz7o707cxwkh	Ring	1	70.00	20	80
moz7tzlrpw9e6	moz77ix06i9sv	Pendant	2	50.00	10	90
moz889n8aqdig	moz7hppskqcsd	Ring	9	125.00	100	0
mp4wp5w1mz4o4	mp4wp5h76km34	Ring	1	70.00	100	0
mp4wp64txm9yh	mp4wp5h76km34	Bracelet	2	50.00	100	0
mp4wp6czhpi7w	mp4wp5h76km34	Earrings	1	70.00	100	0
mp4wprsnu21lv	mp4wpr9d6bvj1	Other	7	25.00	100	0
mpaqdf0uuts6c	mpaqdd6r0ugai	Ring	1	70.00	100	0
mpaqdfak9v6gj	mpaqdd6r0ugai	Ring	1	70.00	100	0
mpj1rf0prbx2s	mpj1rdvb2aaz5	Bracelet	2	50.00	100	0
mpj1vfzxy5bv1	mpj1vfbpb3im9	Other	7	20.00	100	0
mpj1xy08ozw36	mpj1xxhfmalm2	Ring	1	70.00	100	0
mpj1xy8u0vvut	mpj1xxhfmalm2	Ring	1	70.00	100	0
mpj230qg5zd6q	mpj22zvnejwt3	Ring	1	70.00	100	0
mpj230yw5f45v	mpj22zvnejwt3	Ring	1	70.00	100	0
mpj23172qihwr	mpj22zvnejwt3	Ring	1	70.00	100	0
mpj257btmd6wu	mpj256tgtwlqb	Pearls	6	30.00	100	0
mpj26ux7l9xvc	mpj26unn5a747	Pearls	6	70.00	100	0
mpj285ifv4pn9	mpj2850b8oj01	Ring	1	70.00	100	0
mpj2ac8ih30xy	mpj2aby40he8w	Necklace	2	50.00	0	100
mpn7m2d0vlmbc	mpn7m1rcl6fpy	Ring	10	25.00	100	0
mpn7m2ml92l9s	mpn7m1rcl6fpy	Ring	1	70.00	100	0
mpqezkdwmmgdf	mpqezio663wvh	Necklace	10	25.00	0	100
mpqezknvim482	mpqezio663wvh	Necklace	10	25.00	0	100
mpqfxv79ixwsa	mpqfxtmmxda0p	Necklace	10	25.00	0	100
mpqfxvg14toqs	mpqfxtmmxda0p	Necklace	10	25.00	0	100
mpqfxvo6t0tdg	mpqfxtmmxda0p	Necklace	10	25.00	0	100
mpqgqlluali1o	mpqgqk087ln3z	Bracelet	10	25.00	0	100
mpqgqlu9h9urh	mpqgqk087ln3z	Bracelet	10	25.00	0	100
mpqgqm29olusz	mpqgqk087ln3z	Bracelet	10	25.00	0	100
mpqhaoggl9zpq	mpqhamsm7qisj	Bracelet	10	25.00	0	100
mpqhd5u47zv45	mpqbei6pycqa3	Other	2	50.00	0	100
mpqhd62rnkkmd	mpqbei6pycqa3	Other	2	50.00	0	100
mpqhd6b3oc1ws	mpqbei6pycqa3	Necklace	2	50.00	0	100
mprlumq0m7uwg	mprluky6094oh	Earrings	10	25.00	50	50
mprlun01e881e	mprluky6094oh	Other	10	25.00	0	100
mprlun8hb265b	mprluky6094oh	Earrings	2	50.00	0	100
mpt1gf007j741	mpt1gd57dbvz7	Ring	9	25.00	50	50
mpt26c4do7l9r	mpt26ajgnvx4q	Ring	1	70.00	10	90
mpt50a6jjcf4k	mpt508j5zmqoz	Ring	7	25.00	0	100
mpt50aghg2ji1	mpt508j5zmqoz	Ring	7	25.00	0	100
mpt50aozxduvc	mpt508j5zmqoz	Ring	7	25.00	0	100
mpugk2lqauxkq	mpugk0xnwdp83	Ring	1	70.00	80	20
mpugk2x6m0efq	mpugk0xnwdp83	Bracelet	7	25.00	0	100
mpugmaaz5vxm3	mpugm9vpaqlad	Ring	9	25.00	100	0
mpugmaiyzdf56	mpugm9vpaqlad	Ring	9	25.00	100	0
mpugmaqx2hasv	mpugm9vpaqlad	Ring	9	25.00	100	0
mpugmz0lbtn0u	mpugmys012a6x	Ring	9	25.00	100	0
mpugp3b43zv4g	mpugp2pbqjpfw	Pearls	6	50.00	100	0
mpugrxvav9c99	mpugrx2kzmb16	Pendant	1	70.00	100	0
mpugsrb7ds5fa	mpugsr1curnij	Bracelet	1	70.00	100	0
mq4luw20rb8ln	mq4luv5dh8ef0	Ring	10	25.00	100	0
mq4luwbjazwca	mq4luv5dh8ef0	Ring	10	25.00	100	0
mq4lwb46bllwl	mq4lwahr7u5nx	Ring	7	25.00	100	0
mq4qkjztfn3y0	mq4qkjogkwsjc	Pendant	7	25.00	100	0
mq4qmk9azv9jk	mq4qmjvhqi0xj	Other	7	25.00	100	0
mq4qmkj012611	mq4qmjvhqi0xj	Other	7	25.00	100	0
mq4qpyuftzxqn	mq4qlnop9rbs5	Bracelet	2	50.00	100	0
mq4qpz29yw885	mq4qlnop9rbs5	Bracelet	2	50.00	100	0
mq4qr8re13ju9	mq4qr8ekal6k7	Ring	1	70.00	100	0
mq4qslxuekv37	mq4qskulr1hmy	Ring	10	25.00	100	0
mq4qsmgfjd5w5	mq4qskulr1hmy	Ring	10	25.00	0	100
mq4qsmo3gpafu	mq4qskulr1hmy	Pendant	10	25.00	0	100
mq4quiqbn9nzw	mq4qui5ys3g91	Necklace	10	25.00	0	100
mq4quj1n7ql7w	mq4qui5ys3g91	Bracelet	10	25.00	0	100
mq4qujacvrmax	mq4qui5ys3g91	Necklace	10	25.00	0	100
mq4qujlic1l7p	mq4qui5ys3g91	Bracelet	2	37.50	0	100
mq4qvm5mt7r63	mq4qvld2seu0r	Pendant	10	25.00	100	0
mq4qwpksnalte	mq4qwp9mnhj91	Ring	1	70.00	10	90
mq4qwptutlq7d	mq4qwp9mnhj91	Ring	1	70.00	20	80
mq4qwq22drjns	mq4qwp9mnhj91	Ring	1	70.00	10	90
mq4qzq5cnz1g7	mq4qyzhs0tsts	Earrings	1	70.00	10	90
mq4qzqdv5pjjt	mq4qyzhs0tsts	Other	2	37.50	0	100
mq4qzqlmfztwi	mq4qyzhs0tsts	Necklace	2	37.50	0	100
mq4r0sn6ipptn	mq4r0sciq4w36	Necklace	2	37.50	0	100
mq8nb58bwkv47	mq8nb4mqfgqwt	Pendant	1	70.00	100	0
mqbpe0eldcmoi	mqbpe045n27xc	Ring	11	50.00	0	100
mqbpegylxglct	mqbpegq676dmi	Ring	1	70.00	10	90
mqoqg18gszj2p	mqoqfzn9ar9dn	Ring	7	25.00	30	70
mqosdl9sl71w6	mqosdjmmli3cj	Ring	4	50.00	100	0
mqoselgj16ucb	mqosel7fq4gav	Ring	10	25.00	100	0
mqeqgmrur2ds5	mqeqfilhk1jgt	Ring	4	50.00	100	0
mqeqgn05828px	mqeqfilhk1jgt	Ring	4	50.00	100	0
mqeqgn81pic7p	mqeqfilhk1jgt	Ring	4	50.00	100	0
mqosfgx83q5w7	mqosfgiequ4bc	Pendant	2	37.50	0	100
mqrjrvwibpokp	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrw5qirrho	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrwdsc3cs5	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrwme1cgw2	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrwuoben34	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrx3bpojji	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqrjrxbpxz89i	mqrcfrw7u2qg9	Other	7	25.00	100	0
mqopjdq85npq8	mqopjc2dd1alz	Ring	1	70.00	10	90
mqsq3spq5cp9l	mqsq37f0lk58s	Ring	1	70.00	100	0
mqwzmpimnp2s8	mqwzmp2xu0gi3	Ring	10	25.00	0	100
mqx3v73wz879z	mqx3v5c1xcm8y	Ring	1	70.00	10	90
mqx3v7dboivtm	mqx3v5c1xcm8y	Ring	2	37.50	0	100
mqojuu07mlorr	mqojusc7umv9m	Gemstone	7	21.74	100	0
mrfm1zb8irikr	mrfm1z0pba2hm	Ring	1	70.00	50	50
mqsq1qsuwzy27	mqsq1qgua6gne	Gemstone	1	21.74	100	0
mqoplqpqyns5x	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplqxrg90r8	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplr61dcn36	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplrecswift	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplrm7skjoz	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplru8n3w3k	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqopls35l0tz1	mqogj7o7j90h4	Gemstone	7	25.00	50	50
mqoplsb8o1lz8	mqogj7o7j90h4	Ring	1	100.00	100	0
mqoplsjcy1y8f	mqogj7o7j90h4	Bracelet	2	37.50	0	100
mqzyk28wbjmxq	mqzyk1w155bzp	Other	8	25.00	100	0
mr1crz8wjl4ev	mqk2mbiffsn6a	Pendant	1	70.00	100	0
mr1d2kqtq2uru	mqzyf101brrrs	Bracelet	2	70.00	100	0
mr1d2l0dd1mi6	mqzyf101brrrs	Bracelet	2	70.00	100	0
mr1d3udx270pf	mqzyhpxdrmdrq	Pendant	2	50.00	100	0
mr1ggzop0yigy	mqzyglxtan1om	Bracelet	2	50.00	100	0
mr1gift3yyy1f	mqzyl9o0opun2	Other	7	25.00	100	0
mr2x6wobnrvek	mr2x6wedew0j4	Ring	1	70.00	10	90
mr2x79j5cydpp	mr2x674vdn0aa	Ring	1	70.00	50	50
mr316acwepyyk	mr3169xk3qvg3	Other	6	50.00	100	0
mr317678pm5jy	mr3175syumw0c	Ring	4	50.00	100	0
mr474s9jgwlzd	mr474ryz3l32m	Bracelet	1	70.00	10	90
mr4dlaa1g0hic	mr4dl9nmf960t	Pearls	6	45.00	100	0
mr4dmscqxhw30	mr4dmrr7hhh3q	Pearls	6	65.00	100	0
mr4efkn9sohtx	mr4ecwp52kgcm	Necklace	2	50.00	0	100
mr4efkvdo7gv4	mr4ecwp52kgcm	Bracelet	3	70.00	0	100
mr4efl3nqvf7h	mr4ecwp52kgcm	Ring	5	40.00	0	100
mr4eflbv85keo	mr4ecwp52kgcm	Ring	4	50.00	0	100
mr4ht07bhmctg	mr4hszniyal7s	Ring	10	25.00	0	100
mr5mqi5xbbgdy	mr5mqhl1i7718	Ring	4	50.00	0	100
mr5mqig6q325w	mr5mqhl1i7718	Ring	5	40.00	0	100
mr5mqiomj2m04	mr5mqhl1i7718	Ring	4	50.00	20	80
mr5qhl9798uiw	mr5qhkl68th39	Ring	1	70.00	0	100
mr5qhljvqyga3	mr5qhkl68th39	Ring	1	70.00	0	100
mr5qienbt6o5p	mr5qied778ml9	Ring	4	50.00	0	100
mr5qievo2c0ch	mr5qied778ml9	Ring	4	50.00	0	100
mr5qif3w6si1k	mr5qied778ml9	Ring	4	50.00	0	100
mrbddbr1ir39x	mrbddb4v049b1	Other	10	25.00	100	0
mrbddc0ajo2q1	mrbddb4v049b1	Bracelet	10	25.00	100	0
mrbdflceaor0v	mrbdfkxqvizdj	Ring	4	50.00	100	0
mrbdfllb064zy	mrbdfkxqvizdj	Ring	4	50.00	100	0
mrbdfltoaoxmo	mrbdfkxqvizdj	Ring	5	40.00	100	0
mrct12p7nn260	mrct12e2hgcp0	Ring	1	70.00	100	0
mregb68lvzv9q	mregb5wntofgd	Pendant	1	70.00	10	90
mregb6i4cifbq	mregb5wntofgd	Ring	1	70.00	0	100
mregb6qqm7hqj	mregb5wntofgd	Ring	1	70.00	0	100
mregb6z4i75vq	mregb5wntofgd	Ring	2	50.00	0	100
mrfm2t3f69jgf	mrfm2sgh5csy8	Ring	1	70.00	10	90
mrfm3pcvbwalq	mrfm3otmkt3rh	Ring	1	70.00	50	50
mrfneqn4tsz1r	mrfneqd55tfgi	Ring	1	70.00	10	90
mrfneqvcn8aqd	mrfneqd55tfgi	Ring	1	70.00	10	90
mrfoznxacus9z	mrfoznnh65taa	Ring	2	50.00	0	100
mrfqrbex6mv0v	mrfqrav7z307y	Pendant	10	50.00	0	100
mrfqrbn4ky65c	mrfqrav7z307y	Bracelet	10	25.00	0	100
mrl94ekid71j6	mrl94e2adhowx	Ring	1	75.00	100	0
mro9ko35ef4nf	mro9kmtncvkxn	Ring	1	50.00	0	100
mrog7ghy4ead3	mrog7fpk0272s	Bracelet	2	50.00	0	100
mrog7gsg9n8ys	mrog7fpk0272s	Necklace	2	50.00	0	100
mroh3iifxav6h	mroh3gvifseup	Ring	1	91.00	100	0
mroh3ir9w6uwz	mroh3gvifseup	Pendant	1	91.00	100	0
mroh3izqda85k	mroh3gvifseup	Earrings	1	91.00	100	0
mroi3v1x1u7uy	mroi33om7hpkl	Ring	10	25.00	0	100
mroi3va3cb3dy	mroi33om7hpkl	Brooch	10	25.00	50	50
mroi3viej8dy6	mroi33om7hpkl	Ring	10	25.00	0	100
mroi3vqkusqd6	mroi33om7hpkl	Ring	1	70.00	0	100
mrphsrtt6b87q	mrphsr5xh0u0b	Ring	1	70.00	0	100
mrpmh0w6v2rzb	mrpmh0645mpaw	Necklace	2	50.00	0	100
mrpmh17aqw8bx	mrpmh0645mpaw	Necklace	2	50.00	0	100
mrpmh1fr0lspz	mrpmh0645mpaw	Necklace	2	50.00	0	100
mrpmh1o3252kv	mrpmh0645mpaw	Bracelet	2	50.00	0	100
mrptbwr9f7vol	mrptbw1lcmdhk	Ring	1	70.00	10	90
mrptcw1xp8aqj	mrptcvn63dult	Ring	1	70.00	25	75
mrsi9qukbhsmv	mrsi9qebtaqp4	Pendant	4	50.00	100	0
mrsib15uq5zgj	mrsib0jva7s4x	Ring	1	70.00	100	0
mrsibtu7een63	mrsibtkon1wfp	Ring	1	70.00	100	0
mrsid0975wkx1	mrsiczyyhp1lq	Ring	7	10.00	100	0
mrtwv8c3yh9le	mrtwv80kej5fm	Ring	1	100.00	100	0
mrtwv8levb84u	mrtwv80kej5fm	Ring	1	100.00	100	0
mrv9hulkwxjbz	mrv9hub1txk5s	Ring	1	70.00	100	0
mrv9mqms4vwy9	mrv9mqcb9xd7m	Ring	2	50.00	100	0
mrydaum2liecw	mrydatw29mt9e	Bracelet	1	70.00	0	100
mrydauwbt1zfd	mrydatw29mt9e	Earrings	1	70.00	0	100
mrydav40x4yr6	mrydatw29mt9e	Bracelet	2	50.00	0	100
mrydavc8w90q6	mrydatw29mt9e	Ring	1	70.00	20	80
mrydavkk1eysk	mrydatw29mt9e	Earrings	1	70.00	20	80
mrydbmi7gohef	mrydbm91q8m80	Ring	1	70.00	0	100
mryenp5v7n98r	mryennigsa21h	Ring	10	25.00	0	100
mryjbmyv3t7um	mryjbmcst7rp6	Ring	1	70.00	10	90
mryjcbu928213	mryjcb8k0ksbz	Ring	1	70.00	10	90
mrzn74ax4zmzp	mrzn73i8c3xh6	Ring	1	70.00	10	90
mrzrnw6lq99z2	mrzrnvet0hxx6	Bracelet	1	70.00	10	90
ms3zfsyfgc71e	ms3zfs2vaz0dx	Ring	1	70.00	100	0
ms3zhlhommyvc	ms3zhksmeegro	Necklace	2	50.00	100	0
ms3ziydy60qcs	ms3ziy4esct4s	Bracelet	1	70.00	100	0
ms5dca9nt9rds	ms5dc9ls5i30n	Ring	1	70.00	100	0
ms5dcaij7w0lf	ms5dc9ls5i30n	Ring	1	70.00	100	0
ms5dd6tzucmjl	ms5dd6kp6o6k0	Ring	1	70.00	100	0
ms5ddt2v96016	mrl95pe2ahahq	Necklace	5	40.00	100	0
ms6rdfyx6ap7e	ms6rdf7hx2vmk	Ring	1	70.00	100	0
ms6rfkd3lzwpb	ms6rfjq9s7m7p	Bracelet	2	50.00	100	0
ms6rfklgrjenk	ms6rfjq9s7m7p	Ring	1	70.00	100	0
ms6rh7futr2fe	ms6rh6wp41xzk	Ring	1	70.00	100	0
ms6rid593wjlp	ms6riciinmciv	Ring	10	50.00	100	0
ms844mqzopqhz	ms844mesr521t	Ring	1	70.00	100	0
ms878768txri6	ms8785faz8btf	Ring	1	70.00	100	0
msdx5b5cifrqo	msdx5asmry60j	Ring	1	70.00	100	0
msdx641u5k6s3	msdx63s56h1wm	Ring	1	70.00	100	0
msdx6zfy80r58	msdx6yx3gkbtb	Ring	1	70.00	100	0
msdx86dqd5x6b	msdx863qkegfg	Necklace	2	50.00	100	0
msfmuubrcvh83	msfmuskhdf6nd	Pearls	6	30.00	100	0
msfnnazx5n9h2	msfnn9fr5rgqm	Pendant	2	50.00	0	100
msi7vvbw7o54y	msfdtmkoajamq	Bracelet	3	85.00	50	50
msi7vvl62v2w4	msfdtmkoajamq	Bracelet	3	85.00	60	40
msi7vvte16c3y	msfdtmkoajamq	Earrings	3	85.00	0	100
msi7vw1ron0pj	msfdtmkoajamq	Pendant	3	85.00	0	100
msi7wx5aua1da	msi7wwuqjnlkp	Ring	1	70.00	10	90
msi7xpgpbykc7	msi7xp6h9ftli	Earrings	1	70.00	20	80
msic13ramelnq	msic132y8nuit	Ring	1	70.00	0	100
msic142ef26mi	msic132y8nuit	Ring	1	70.00	0	100
msif97wsnknhl	msif977yjzhuk	Ring	2	50.00	0	100
msif9my0hvb01	msif9mp8baq6b	Ring	1	70.00	0	100
msigaymopykio	msigax6d495a7	Ring	1	70.00	0	100
msii3nacos9wt	msii3mauk6n5y	Other	2	50.00	0	100
msii3njqgk741	msii3mauk6n5y	Other	2	50.00	0	100
msii3ns30zt0o	msii3mauk6n5y	Other	5	40.00	0	100
msii3nzzp3ibv	msii3mauk6n5y	Other	5	40.00	0	100
msjlnjd879qst	msjlniqdsjjoz	Ring	1	70.00	0	100
msjmm2up3opoj	msjmm15p4mg5j	Ring	1	70.00	0	100
msqrkqtlms1fa	msqrkqi7bxz97	Ring	1	70.00	100	0
msqrodqly7org	msqrod0n9w3og	Ring	2	50.00	100	0
msqrodzqcpost	msqrod0n9w3og	Ring	1	70.00	100	0
msqroe8rnp6te	msqrod0n9w3og	Ring	3	140.00	100	0
msqrqsij9nxwt	msqrqs2f7sniy	Necklace	2	70.00	100	0
msqrs7j90laxj	msmiduqu4eoor	Gemstone	7	25.00	100	0
mss395woyyvsn	mss395lkr8rtz	Bracelet	2	50.00	100	0
mss3alg6675vq	mss3ak1s4eosl	Ring	7	10.00	100	0
mswio2qrjewyx	mswio2ft4owuo	Ring	1	70.00	100	0
mswio31jj9mmg	mswio2ft4owuo	Ring	1	70.00	100	0
msxukbwgcvqrq	msxukba536cw9	Ring	1	70.00	100	0
msxukc7dqkfg2	msxukba536cw9	Earrings	1	70.00	100	0
mszdyhhorm2e4	mszdyh6m4i677	Ring	1	70.00	0	100
mszgnti5n20ho	mszgns9iyq3rk	Ring	1	70.00	0	100
mszl6o8wus14m	mszl6muvkaa4h	Ring	3	80.00	0	100
mszn59f8idme8	mszn57spsc60k	Ring	9	25.00	0	100
mt0rv45zm8nbg	mt0rv3ifoug4i	Ring	1	70.00	0	100
mt0rv4t3b9yui	mt0rv3ifoug4i	Ring	1	70.00	0	100
mt0rv51qzkphd	mt0rv3ifoug4i	Ring	10	25.00	0	100
mt0rv5mo8v8yn	mt0rv3ifoug4i	Ring	5	40.00	0	100
mt0rv5v935tp7	mt0rv3ifoug4i	Ring	5	40.00	0	100
mt17u81bsngc9	mt17u7bodc1i5	Ring	1	70.00	0	100
mt17u8p024jo8	mt17u7bodc1i5	Ring	1	70.00	0	100
mt17utc0hsqvx	mt17ut30b9tz4	Ring	1	70.00	0	100
mt17utkhoug7m	mt17ut30b9tz4	Ring	1	70.00	0	100
mt17vg2g6vc8e	mt17vfoioycry	Bracelet	1	70.00	0	100
mt17vgawju4ej	mt17vfoioycry	Necklace	2	50.00	0	100
mt5bk53sqcntk	mt5bk49gu70im	Ring	1	70.00	100	0
mt5bk5eq81qm9	mt5bk49gu70im	Ring	1	70.00	100	0
mt5blsn2zjs7e	mt5bls996yt0b	Ring	11	50.00	100	0
mt7worw7tep32	mt7worh10uzy5	Ring	10	25.00	0	100
mt83lazcepfe3	mt83l99oljqy2	Pendant	1	85.00	0	100
mt9me4l8bl1oz	mt9me3z3yju5z	Ring	1	70.00	100	0
mt9me58ghs7ke	mt9me3z3yju5z	Ring	1	70.00	100	0
mt9mg2wia3ljp	mt9mg29rp10jt	Necklace	2	50.00	100	0
mt9mhk15vq7ew	mt9mhjri3t55u	Ring	4	50.00	100	0
mt9ml8h2e1jnu	mt9ml85xpobuh	Bracelet	10	25.00	100	0
mtarft26movzd	mtarfsjxjhr17	Ring	1	93.00	0	100
mtav37xmm9jrn	mtav361dmg3r6	Ring	1	80.00	0	100
mtc3avgbxfjg0	mt9mj7e59er4y	Necklace	1	90.00	50	50
mtc5yet2uaumz	mtc5ydhvqi2n2	Ring	3	80.00	0	100
mtc5yfgehlqtu	mtc5ydhvqi2n2	Ring	1	70.00	10	90
mtc5yfoocuq1t	mtc5ydhvqi2n2	Ring	1	70.00	0	100
mtc5yfvrextl3	mtc5ydhvqi2n2	Ring	1	70.00	10	90
mtce7gqxsqysa	mtce7fdtdl7nf	Ring	1	70.00	0	100
mtce7h03lhm9t	mtce7fdtdl7nf	Ring	1	70.00	0	100
mtce7h8t2qdda	mtce7fdtdl7nf	Bracelet	2	50.00	0	100
mtchlrks8ac83	mtchlqxhnq11h	Pendant	6	65.00	100	0
\.


--
-- Data for Name: packets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.packets (id, date, retailer_id, customer_ref, surname, created, modified, status_id, paula_billed, gabby_billed, sub_customer, shipping_run_id, sub_customer_id) FROM stdin;
mp4wpr9d6bvj1	14 May 2026	2	002-47994	Fisher	14 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpn7m1rcl6fpy	27 May 2026	1	001-19882	Bosman	27 May 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpj2850b8oj01	18 May 2026	2	002-45408	Bell	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
moz6wt6nu4oza	01 May 2026	1	001-198301	Mckinlay	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
moz7igl8hq1en	08 May 2026	2	002-99999	Stock Update	10 May 2026	14 May 2026	3	f	t	\N	\N	\N
moz77ix06i9sv	02 May 2026	1	001-198125	Macinnes	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
moz7d2eyt841f	10 May 2026	1	001-198447	Wilson	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz7n9sundg6n	09 May 2026	1	001-198364	Weaver	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
mpt26ajgnvx4q	31 May 2026	2	002-48262	Campbell	31 May 2026	01 Jun 2026	3	t	t	\N	\N	\N
moz6zvc6tdyci	01 May 2026	2	002-47692	Pile	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
moz71boglfxhy	01 May 2026	1	001-19836	Van Zijl	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz72syh1uq4q	01 May 2026	2	002-47570	Huitt	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
mpt508j5zmqoz	31 May 2026	2	002-48261	Campbell	31 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
moz7brblz5m7t	04 May 2026	2	002-99999	Customer Updates (multiple Sales)	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz7gnp4qtcph	06 May 2026	1	001-99999	Clouston	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz7hppskqcsd	07 May 2026	2	002-99999	Stock Updates (5)	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz7kzy24sk6h	08 May 2026	2	002-47933	Stock New	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
moz7lu6zjfg9a	08 May 2026	1	001-19852	Schuck	10 May 2026	14 May 2026	3	t	f	\N	\N	\N
moz7o707cxwkh	10 May 2026	2	002-47907	Hamilton	10 May 2026	14 May 2026	3	t	t	\N	\N	\N
mp4wp5h76km34	12 May 2026	1	001-128575	Brass	14 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpaqdd6r0ugai	14 May 2026	1	001-198675	Kats	18 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpj1rdvb2aaz5	14 May 2026	1	001-198571	Andrews	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpj1vfbpb3im9	15 May 2026	1	001-198698	Marshall	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpj1xxhfmalm2	15 May 2026	1	001-198679	Lawrence	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpj22zvnejwt3	15 May 2026	1	001-198674	Tohill	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpugm9vpaqlad	26 May 2026	2	002-99999	Stock	01 Jun 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpj256tgtwlqb	16 May 2026	1	001-198676	Marshall	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpj26unn5a747	17 May 2026	1	001-198034	Pollock	24 May 2026	24 May 2026	3	t	f	\N	\N	\N
mpugk0xnwdp83	25 May 2026	2	002-48152	Hocklin	01 Jun 2026	01 Jun 2026	3	t	t	\N	\N	\N
mpugmys012a6x	26 May 2026	2	002-999999	Stock	01 Jun 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpugp2pbqjpfw	27 May 2026	2	002-48159	Wood	01 Jun 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpugrx2kzmb16	28 May 2026	1	001-198672	Arthur	01 Jun 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpugsr1curnij	28 May 2026	1	001-198672	Johns	01 Jun 2026	01 Jun 2026	3	t	f	\N	\N	\N
mpj2aby40he8w	24 May 2026	1	001-198073	Smith	24 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mpqbei6pycqa3	29 May 2026	1	001-198905	Kilgour	29 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mpqezio663wvh	29 May 2026	1	001-198890	Kilgour	29 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mpqfxtmmxda0p	29 May 2026	1	001-198894	Kilgour	29 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mpqgqk087ln3z	29 May 2026	1	001-198904	Kilgour	29 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mpqhamsm7qisj	29 May 2026	1	001-198891	Kilgour	29 May 2026	01 Jun 2026	3	f	t	\N	\N	\N
mprluky6094oh	30 May 2026	1	001-198893	Kilgour	30 May 2026	01 Jun 2026	3	t	t	\N	\N	\N
mpt1gd57dbvz7	31 May 2026	2	002-99999	Green	31 May 2026	01 Jun 2026	3	t	t	\N	\N	\N
mq4luv5dh8ef0	02 Jun 2026	1	001-198921	Joyce	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqogj7o7j90h4	22 Jun 2026	2	002-48580	Worthington	22 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qkjogkwsjc	02 Jun 2026	2	002-48260	Campbell	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4lwahr7u5nx	02 Jun 2026	1	001-198932	De Koning	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qr8ekal6k7	04 Jun 2026	2	002-48259	Anderson	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qvld2seu0r	04 Jun 2026	1	001-199027	Jephson	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qyzhs0tsts	06 Jun 2026	2	002-48312	Blee - Estate Of	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qskulr1hmy	04 Jun 2026	1	001-198985	Smith	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqbpegq676dmi	13 Jun 2026	2	002-48453	Murray	13 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qui5ys3g91	05 Jun 2026	1	001-198987	Smith	08 Jun 2026	01 Jul 2026	3	f	t	\N	\N	\N
mqk2mbiffsn6a	19 Jun 2026	2	002-48545	O'donnell	19 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qwp9mnhj91	05 Jun 2026	2	002-48311	Hickey	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qlnop9rbs5	03 Jun 2026	1	001-198933	Maloney	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4qmjvhqi0xj	03 Jun 2026	1	001-198906	Kilgour	08 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq4r0sciq4w36	08 Jun 2026	1	001-199031	Hewitt	08 Jun 2026	01 Jul 2026	3	f	t	\N	\N	\N
mqbpe045n27xc	13 Jun 2026	2	002-999999	Stock	13 Jun 2026	01 Jul 2026	3	f	t	\N	\N	\N
mqoqfzn9ar9dn	22 Jun 2026	1	001-199284	Cover	22 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mq8nb4mqfgqwt	11 Jun 2026	1	001-198877	Moloney	11 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqopjc2dd1alz	22 Jun 2026	1	001-199279	Brown	22 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqeqfilhk1jgt	15 Jun 2026	2	002-48313	Blee	15 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqwzmp2xu0gi3	28 Jun 2026	2	002-999999	Hughes	28 Jun 2026	01 Jul 2026	3	f	t	\N	\N	\N
mrzrnvet0hxx6	25 Jul 2026	3	207252	Stock	25 Jul 2026	04 Aug 2026	3	t	t	\N	ms43xhg3ewv3x	sc_jds
mqsq37f0lk58s	25 Jun 2026	2	002-48395	Gray	25 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqx3v5c1xcm8y	28 Jun 2026	2	002-48667	Watson	28 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mr5mqhl1i7718	04 Jul 2026	2	002-48864	Arbuckle	04 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr4hszniyal7s	03 Jul 2026	2	002-999999	Brooks	03 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mqosfgiequ4bc	22 Jun 2026	1	001-199056	Kilgour	22 Jun 2026	01 Jul 2026	3	f	t	\N	\N	\N
mrfm2sgh5csy8	11 Jul 2026	3	1-4808	Stock - Chocolate Diamond	11 Jul 2026	04 Aug 2026	3	t	t	\N	mrin41vdi136h	sc_jds
mqsq1qgua6gne	25 Jun 2026	3	135056	Mackay	25 Jun 2026	04 Aug 2026	3	t	t	Van de Waters	mqu215igg6t2h	sc_vandewater
mrfm1z0pba2hm	11 Jul 2026	3	2-3856	Stock - Emerald Pear	11 Jul 2026	04 Aug 2026	3	t	t	\N	mrin41vdi136h	sc_jds
mqosdjmmli3cj	10 Jun 2026	1	001-198521	Mcgray	22 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqosel7fq4gav	11 Jun 2026	1	001-9999	Mcdermott	22 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqrcfrw7u2qg9	24 Jun 2026	1	001-199317	Norris	24 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqzyf101brrrs	30 Jun 2026	1	001-199432	Robertson	30 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqzyglxtan1om	30 Jun 2026	1	001-199427	Holgate	30 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqzyhpxdrmdrq	30 Jun 2026	1	001-199427	Robertson	30 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqzyk1w155bzp	30 Jun 2026	1	001-199430	Chambers	30 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mqzyl9o0opun2	30 Jun 2026	1	001-199421	Brogan	30 Jun 2026	01 Jul 2026	3	t	t	\N	\N	\N
mrfm3otmkt3rh	11 Jul 2026	3	2-3979	Stock - Tanzanite	11 Jul 2026	04 Aug 2026	3	t	t	\N	mrin41vdi136h	sc_jds
mrptcvn63dult	18 Jul 2026	3	8030408	Sutherland	18 Jul 2026	04 Aug 2026	3	t	t	\N	mru46ydjwrqu6	sc_gmw
mrpmh0645mpaw	18 Jul 2026	1	001-199726	Meehan	18 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mrl94e2adhowx	15 Jul 2026	3	135188	Johanson	15 Jul 2026	04 Aug 2026	3	t	t	\N	mrlgnz36kkd0a	sc_vandewater
mrsib0jva7s4x	20 Jul 2026	3	8030406	Mcmillan	20 Jul 2026	04 Aug 2026	3	t	t	\N	mru46ydjwrqu6	sc_gmw
mro9kmtncvkxn	17 Jul 2026	3	135212	Symons	17 Jul 2026	04 Aug 2026	1	f	t	\N	mrsk49mw14vty	sc_vandewater
mrptbw1lcmdhk	18 Jul 2026	3	8030409	Sutherland	18 Jul 2026	04 Aug 2026	3	t	t	\N	mru46ydjwrqu6	sc_gmw
mrphsr5xh0u0b	18 Jul 2026	3	8030401	Weaver	18 Jul 2026	04 Aug 2026	1	f	t	\N	mru46ydjwrqu6	sc_gmw
mrtwv80kej5fm	21 Jul 2026	3	004000	Johnson	21 Jul 2026	04 Aug 2026	3	t	t	\N	mru4ihjy2f6jg	sc_gmw
mrsibtkon1wfp	20 Jul 2026	3	8030407	Bruick	20 Jul 2026	04 Aug 2026	3	t	t	\N	mru4ihjy2f6jg	sc_gmw
mryjbmcst7rp6	24 Jul 2026	3	135239	Marrable	24 Jul 2026	04 Aug 2026	3	t	t	\N	ms2iwr2vy22s8	sc_vandewater
ms3zfs2vaz0dx	28 Jul 2026	3	8030417	Mcleod	28 Jul 2026	04 Aug 2026	3	t	t	\N	ms440t8qbid48	sc_gmw
mryjcb8k0ksbz	24 Jul 2026	3	135240	Marrable	24 Jul 2026	04 Aug 2026	3	t	t	\N	ms2iwr2vy22s8	sc_vandewater
mr2x6wedew0j4	01 Jul 2026	3	3975	Forbes	02 Jul 2026	04 Aug 2026	3	t	t	\N	ms9yq3xn4fp41	sc_gmw
mrog7fpk0272s	17 Jul 2026	1	001-199713	Hargreaves	17 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mr2x674vdn0aa	01 Jul 2026	3	3979	Boock	02 Jul 2026	04 Aug 2026	3	t	t	\N	ms9yq3xn4fp41	sc_gmw
mr4ecwp52kgcm	03 Jul 2026	2	002-48853	Arbuckle	03 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mrct12e2hgcp0	09 Jul 2026	2	002-48924	Spicer	09 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrfneqd55tfgi	11 Jul 2026	2	002-48776	Smith	11 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrsiczyyhp1lq	20 Jul 2026	2	002-49111	Mellor	20 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrv9hub1txk5s	22 Jul 2026	2	002-48865	Arbuckle	22 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrv9mqcb9xd7m	22 Jul 2026	2	002-48967	Busst	22 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrydatw29mt9e	24 Jul 2026	2	002-49181	Edwards	24 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
ms3zhksmeegro	27 Jul 2026	2	002-44093	Edwards	28 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr3175syumw0c	02 Jul 2026	1	001-48285	Mellor	02 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr474ryz3l32m	03 Jul 2026	1	001-199210	Toikey	03 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr4dl9nmf960t	03 Jul 2026	1	001-197135	Bishop	03 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrbddb4v049b1	08 Jul 2026	1	001-199511	Wearing	08 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr5qhkl68th39	04 Jul 2026	1	001-199467	Clark	04 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mr5qied778ml9	04 Jul 2026	1	001-199463	Clark	04 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mrbdfkxqvizdj	08 Jul 2026	1	001-48937	Landeck	08 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mregb5wntofgd	10 Jul 2026	1	001-199606	Smith	10 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrl95pe2ahahq	15 Jul 2026	1	001-199604	Gibb	15 Jul 2026	02 Aug 2026	3	t	t	\N	\N	sc_vandewater
mrfoznnh65taa	11 Jul 2026	1	001-199604	Gibb	11 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mrfqrav7z307y	11 Jul 2026	1	001-199634	Reid	11 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mroi33om7hpkl	17 Jul 2026	1	001-199640	Reid	17 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrsi9qebtaqp4	14 Jul 2026	1	001-199315	Quayle	20 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mr4dmrr7hhh3q	03 Jul 2026	2	002-48883	Clarice	03 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrydbm91q8m80	24 Jul 2026	1	001-199461	Clark	24 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mryennigsa21h	24 Jul 2026	1	001-199638	Reid	24 Jul 2026	02 Aug 2026	3	f	t	\N	\N	\N
mr3169xk3qvg3	02 Jul 2026	1	001-199424	Robb	02 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
msif9mp8baq6b	07 Aug 2026	1	001-199715	Begg	07 Aug 2026	07 Aug 2026	1	f	f	\N	\N	\N
msigax6d495a7	07 Aug 2026	1	001-2000068	Ryan	07 Aug 2026	07 Aug 2026	1	f	f	\N	\N	\N
msii3mauk6n5y	07 Aug 2026	1	001-199833	Wearing	07 Aug 2026	07 Aug 2026	1	f	f	\N	\N	\N
msjlniqdsjjoz	08 Aug 2026	1	001-199906	Lee	08 Aug 2026	08 Aug 2026	1	f	f	\N	\N	\N
msjmm15p4mg5j	08 Aug 2026	1	001-2000090	Mckinlay	08 Aug 2026	08 Aug 2026	1	f	f	\N	\N	\N
mszn57spsc60k	19 Aug 2026	2	002-99999	Carr	19 Aug 2026	19 Aug 2026	1	f	f	\N	\N	\N
mszl6muvkaa4h	19 Aug 2026	3	8030442	Stock	19 Aug 2026	19 Aug 2026	1	f	f	\N	mt0p3l4kghzwz	sc_gmw
mszgns9iyq3rk	19 Aug 2026	3	8030438	Stevens	19 Aug 2026	19 Aug 2026	1	f	f	\N	mt0p3l4kghzwz	sc_gmw
mt0rv3ifoug4i	20 Aug 2026	1	001-200195	Carey	20 Aug 2026	20 Aug 2026	1	f	f	\N	\N	\N
ms6riciinmciv	30 Jul 2026	1	001-199641	Reid	30 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
ms8785faz8btf	31 Jul 2026	1	001-199960	Blackler	31 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mroh3gvifseup	17 Jul 2026	2	002-49092	Edwards	17 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
ms844mesr521t	31 Jul 2026	2	002-49055	Rorrison	31 Jul 2026	02 Aug 2026	3	t	t	\N	\N	\N
mrzn73i8c3xh6	25 Jul 2026	6	Emerald	Stock - Emerald & Diamond Ring	25 Jul 2026	02 Aug 2026	3	t	t	\N	ms429p2rwau28	sc_jewelcraft
msdx863qkegfg	04 Aug 2026	2	002-48401	Tompson	04 Aug 2026	04 Aug 2026	1	f	f	\N	\N	\N
mt17u7bodc1i5	20 Aug 2026	1	001-200262	Armstrong	20 Aug 2026	20 Aug 2026	1	f	f	\N	\N	\N
mt17ut30b9tz4	20 Aug 2026	1	001-200261	Armstrong	20 Aug 2026	20 Aug 2026	1	f	f	\N	\N	\N
mt17vfoioycry	20 Aug 2026	1	001-200263	Armstrong	20 Aug 2026	20 Aug 2026	1	f	f	\N	\N	\N
mt5bk49gu70im	23 Aug 2026	1	001-200294	Cleugh	23 Aug 2026	23 Aug 2026	1	f	f	\N	\N	\N
mt7worh10uzy5	25 Aug 2026	2	002-49270	Edwards	25 Aug 2026	25 Aug 2026	1	f	f	\N	\N	\N
ms6rdf7hx2vmk	30 Jul 2026	3	135276	Crooks	30 Jul 2026	04 Aug 2026	3	t	t	\N	ms6wdi25x08yt	sc_vandewater
ms6rfjq9s7m7p	30 Jul 2026	3	135277	Crooks	30 Jul 2026	04 Aug 2026	3	t	t	\N	ms6wdi25x08yt	sc_vandewater
ms6rh6wp41xzk	30 Jul 2026	3	135265	Young	30 Jul 2026	04 Aug 2026	3	t	t	\N	ms6wdi25x08yt	sc_vandewater
ms5dc9ls5i30n	29 Jul 2026	3	8030421	Sutherland	29 Jul 2026	04 Aug 2026	3	t	t	\N	ms5ip22sfb0sm	sc_gmw
ms5dd6kp6o6k0	29 Jul 2026	3	8030422	Wilson	29 Jul 2026	04 Aug 2026	3	t	t	\N	ms5ip22sfb0sm	sc_gmw
ms3ziy4esct4s	28 Jul 2026	3	206910	Butcher	28 Jul 2026	04 Aug 2026	3	t	t	\N	ms43xhg3ewv3x	sc_jds
mqojusc7umv9m	22 Jun 2026	3	13556	Mackay	22 Jun 2026	04 Aug 2026	3	t	t	Van de Waters	mqon3qjdnytoo	sc_vandewater
msdx5asmry60j	04 Aug 2026	3	207155	Olson	04 Aug 2026	04 Aug 2026	1	f	f	\N	mse3xizbb24y8	sc_jds
msdx63s56h1wm	04 Aug 2026	3	206863	Palmer	04 Aug 2026	04 Aug 2026	1	f	f	\N	mse3xizbb24y8	sc_jds
msi7xp6h9ftli	07 Aug 2026	3	206089	Currin	07 Aug 2026	10 Aug 2026	1	f	f	\N	msnz7hz4xhmou	sc_jds
msfmuskhdf6nd	05 Aug 2026	2	002-49398	Clarke	05 Aug 2026	05 Aug 2026	1	f	f	\N	\N	\N
msfnn9fr5rgqm	05 Aug 2026	2	002-49344	Howden	05 Aug 2026	05 Aug 2026	1	f	f	\N	\N	\N
msfdtmkoajamq	05 Aug 2026	2	002-49278	Edwards	05 Aug 2026	07 Aug 2026	1	f	f	\N	\N	\N
msif977yjzhuk	07 Aug 2026	1	001-200028	Vickery	07 Aug 2026	07 Aug 2026	1	f	f	\N	\N	\N
msdx6yx3gkbtb	04 Aug 2026	3	207155	Olson	04 Aug 2026	10 Aug 2026	1	f	f	\N	msnz7hz4xhmou	sc_jds
mt83l99oljqy2	25 Aug 2026	2	002-49690	Edwards	25 Aug 2026	25 Aug 2026	1	f	f	\N	\N	\N
msic132y8nuit	07 Aug 2026	3	207270	Whitehead	07 Aug 2026	10 Aug 2026	1	f	f	\N	msnz9398r4uny	sc_jds
msi7wwuqjnlkp	07 Aug 2026	3	5264	Stock	07 Aug 2026	10 Aug 2026	1	f	f	\N	msnz9398r4uny	sc_jds
msqrkqi7bxz97	13 Aug 2026	2	002-49553	Banks	13 Aug 2026	13 Aug 2026	1	f	f	\N	\N	\N
msqrod0n9w3og	13 Aug 2026	1	001-200088	Sinnamon	13 Aug 2026	13 Aug 2026	1	f	f	\N	\N	\N
msqrqs2f7sniy	13 Aug 2026	2	002-49311	Edwards	13 Aug 2026	13 Aug 2026	1	f	f	\N	\N	\N
msmiduqu4eoor	10 Aug 2026	3	28-4111	Stock	10 Aug 2026	13 Aug 2026	1	f	f	\N	msnz9398r4uny	sc_jds
mss395lkr8rtz	14 Aug 2026	1	001-200138	Grieve	14 Aug 2026	14 Aug 2026	1	f	f	\N	\N	\N
mss3ak1s4eosl	14 Aug 2026	1	001-200136	Parker	14 Aug 2026	14 Aug 2026	1	f	f	\N	\N	\N
mswio2ft4owuo	17 Aug 2026	2	002-49472	Hogg	17 Aug 2026	17 Aug 2026	1	f	f	\N	\N	\N
msxukba536cw9	18 Aug 2026	1	001-200194	Clements	18 Aug 2026	18 Aug 2026	1	f	f	\N	\N	\N
mszdyh6m4i677	19 Aug 2026	3	206350	Fulton	19 Aug 2026	19 Aug 2026	1	f	f	\N	mszgpsyajq5ga	sc_jds
mt5bls996yt0b	23 Aug 2026	6	Stock	Glen	23 Aug 2026	23 Aug 2026	1	f	f	\N	mt9ebmd71ktx0	sc_jewelcraft
mt9me3z3yju5z	26 Aug 2026	1	001-200351	Knowles	26 Aug 2026	26 Aug 2026	1	f	f	\N	\N	\N
mt9mg29rp10jt	26 Aug 2026	2	002-49366	Waller	26 Aug 2026	26 Aug 2026	1	f	f	\N	\N	\N
mt9mhjri3t55u	26 Aug 2026	2	002-49213	Brundell	26 Aug 2026	26 Aug 2026	1	f	f	\N	\N	\N
mt9ml85xpobuh	26 Aug 2026	1	001-12345	Mc George	26 Aug 2026	26 Aug 2026	1	f	f	\N	\N	\N
mtarfsjxjhr17	27 Aug 2026	2	002-9999	Mellor (urgent)	27 Aug 2026	27 Aug 2026	1	f	f	\N	\N	\N
mtav361dmg3r6	27 Aug 2026	1	001-199494	Norman	27 Aug 2026	27 Aug 2026	1	f	f	\N	\N	\N
mt9mj7e59er4y	26 Aug 2026	2	002-49689	Edwards	26 Aug 2026	28 Aug 2026	1	f	f	\N	\N	\N
mtc5ydhvqi2n2	28 Aug 2026	3	207441	Smythe	28 Aug 2026	28 Aug 2026	1	f	f	\N	\N	sc_jds
mtce7fdtdl7nf	28 Aug 2026	3	207436	Smythe	28 Aug 2026	28 Aug 2026	1	f	f	\N	\N	sc_jds
mtchlqxhnq11h	28 Aug 2026	1	001-200417	White	28 Aug 2026	28 Aug 2026	1	f	f	\N	\N	\N
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, full_name, appraiser_id, created_at) FROM stdin;
cf9e07b5-34a4-4fe8-88f9-0a6818df681d	Gabby	1	2026-07-01 04:49:49.746412+00
2050fcad-2f14-4ee2-ab6e-570abce647a3	Paula	2	2026-07-01 04:49:49.746412+00
7c66f4eb-c3b9-4773-ad14-dd7be65de9b7	Rachel	\N	2026-07-02 00:05:45.500938+00
\.


--
-- Data for Name: retailer_job_type_costs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retailer_job_type_costs (retailer_id, job_type_id, cost) FROM stdin;
\.


--
-- Data for Name: retailers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retailers (id, name, code, discount_pct, combined_billing, requires_shipping) FROM stdin;
1	Alexandra	1	0	f	f
2	Queenstown	2	0	f	f
3	Nationwide Jewellers	3	8.5	t	t
6	Direct	4	0	f	t
\.


--
-- Data for Name: shipping_runs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_runs (id, ship_date, shipping_cost, tracking_last4, retailer_id, sub_customer_name, invoice_number, created, packing_slip_number, sub_customer_id, shipping_cost_billed) FROM stdin;
mqu215igg6t2h	2026-06-25	6.5	3191	3	Van de Waters	INV-0002	2026-06-25	\N	sc_vandewater	\N
mqon3qjdnytoo	2026-06-22	6.5	9932	3	Van de Waters	INV-0001	2026-06-22	\N	sc_vandewater	\N
mrin41vdi136h	2026-07-13	6.5	3165	3	JDs	INV-0003	2026-07-13	\N	sc_jds	\N
mrlgnz36kkd0a	2026-07-15	6.5	0950	3	Van de Waters	INV-0004	2026-07-15	\N	sc_vandewater	\N
mrsk49mw14vty	2026-07-20	6.5	1940	3	Van de Waters	INV-0005	2026-07-20	\N	sc_vandewater	7.15
mru46ydjwrqu6	2026-07-21	6.5	7764	3	GMW Jewellery	INV-0006	2026-07-21	\N	sc_gmw	7.15
mru4ihjy2f6jg	2026-07-21	6.5	6339	3	GMW Jewellery	INV-0007	2026-07-21	\N	sc_gmw	7.15
ms2iwr2vy22s8	2026-07-27	6.5	0159	3	Van de Waters	INV-0008	2026-07-27	\N	sc_vandewater	7.15
ms429p2rwau28	2026-07-28	6.5	2072	6	Jewelcraft	\N	2026-07-28	PS-0001	sc_jewelcraft	6.5
ms43xhg3ewv3x	2026-07-28	6.5	2963	3	JDs	INV-0009	2026-07-28	\N	sc_jds	7.15
ms440t8qbid48	2026-07-28	6.5	6640	3	GMW Jewellery	INV-0010	2026-07-28	\N	sc_gmw	7.15
ms5ip22sfb0sm	2026-07-29	10	7912	3	GMW Jewellery	INV-0011	2026-07-29	\N	sc_gmw	11
ms6wdi25x08yt	2026-07-30	10	2443	3	Van de Waters	INV-0012	2026-07-30	\N	sc_vandewater	11
ms9yq3xn4fp41	2026-07-06	6.5	9999	3	GMW Jewellery	INV-0013	2026-08-01	\N	sc_gmw	6.5
mse3xizbb24y8	2026-08-04	10	4273	3	JDs	INV-0014	2026-08-04	\N	sc_jds	11
msnz7hz4xhmou	2026-08-11	10	6997	3	JDs	INV-0015	2026-08-11	\N	sc_jds	11
msnz9398r4uny	2026-08-11	10	7203	3	JDs	INV-0016	2026-08-11	\N	sc_jds	11
mszgpsyajq5ga	2026-08-19	10	7161	3	JDs	INV-0017	2026-08-19	\N	sc_jds	11
mt0p3l4kghzwz	2026-08-19	10	0302	3	GMW Jewellery	INV-0018	2026-08-19	\N	sc_gmw	11
mt9ebmd71ktx0	2026-08-26	6.5	3380	6	Jewelcraft	\N	2026-08-26	PS-0002	sc_jewelcraft	6.5
\.


--
-- Data for Name: sub_customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_customers (id, retailer_id, name, display_order, address_line1, suburb, city, postcode, bill_to_line) FROM stdin;
sc_jewelcraft	6	Jewelcraft	1	\N	\N	\N	\N	\N
sc_jds	3	JDs	2	42 Western Hills Drive 	Kensington	Whangarei	0112	Nationwide Jewellers – JEW495
sc_vandewater	3	Van de Waters	3	86 Main Street	\N	Gore	9710	Nationwide Jewellers – VAN486
sc_gmw	3	GMW Jewellery	1	91 Weld Street	Redwoodtown	Blenheim	7201	Nationwide Jewellers – GMW433
sc_eversons	3	Eversons	5	\N	\N	\N	\N	Nationwide Jewellers – EVE326
sc_rocks_diamonds	3	Rocks & Diamonds	4	\N	\N	\N	\N	Nationwide Jewellers – ROC432
\.


--
-- Data for Name: tax_invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_invoices (id, invoice_number, shipping_run_id, issue_date, retailer_id, sub_customer_name, status, created, sub_customer_id, nj_statement_id, paid_date, paid_via_payment_id) FROM stdin;
ms9yq54n96o8z	INV-0013	ms9yq3xn4fp41	2026-07-06	3	GMW Jewellery	active	2026-07-31	sc_gmw	msdw5fe8z6kxj	\N	\N
ms6wdjalene6w	INV-0012	ms6wdi25x08yt	2026-07-30	3	Van de Waters	active	2026-07-30	sc_vandewater	msdw5fe8z6kxj	\N	\N
ms5ip3arq84ok	INV-0011	ms5ip22sfb0sm	2026-07-29	3	GMW Jewellery	active	2026-07-29	sc_gmw	msdw5fe8z6kxj	\N	\N
ms43xj3bucgtt	INV-0009	ms43xhg3ewv3x	2026-07-28	3	JDs	active	2026-07-28	sc_jds	msdw5fe8z6kxj	\N	\N
ms440u3jnoiee	INV-0010	ms440t8qbid48	2026-07-28	3	GMW Jewellery	active	2026-07-28	sc_gmw	msdw5fe8z6kxj	\N	\N
ms2iwre899es5	INV-0008	ms2iwr2vy22s8	2026-07-27	3	Van de Waters	active	2026-07-27	sc_vandewater	msdw5fe8z6kxj	\N	\N
mru4iisy3c4bb	INV-0007	mru4ihjy2f6jg	2026-07-21	3	GMW Jewellery	active	2026-07-21	sc_gmw	msdw5fe8z6kxj	\N	\N
mru46zlibgavt	INV-0006	mru46ydjwrqu6	2026-07-21	3	GMW Jewellery	active	2026-07-21	sc_gmw	msdw5fe8z6kxj	\N	\N
mrsk4a79g01fs	INV-0005	mrsk49mw14vty	2026-07-20	3	Van de Waters	active	2026-07-20	sc_vandewater	msdw5fe8z6kxj	\N	\N
mrlgnzrvspdio	INV-0004	mrlgnz36kkd0a	2026-07-15	3	Van de Waters	active	2026-07-15	sc_vandewater	msdw5fe8z6kxj	\N	\N
mrin425h5pyqy	INV-0003	mrin41vdi136h	2026-07-13	3	JDs	active	2026-07-13	sc_jds	msdw5fe8z6kxj	\N	\N
mqu2165imtctq	INV-0002	mqu215igg6t2h	2026-06-25	3	Van de Waters	active	2026-06-25	sc_vandewater	msdw5fe8z6kxj	\N	\N
a26cd551-ca62-424a-ab1b-be76654e6e44	INV-0001	mqon3qjdnytoo	2026-06-22	3	Van de Waters	active	2026-06-22	sc_vandewater	msdw5fe8z6kxj	\N	\N
mse3xk0aqbhmq	INV-0014	mse3xizbb24y8	2026-08-04	3	JDs	active	2026-08-04	sc_jds	\N	\N	\N
msnz7j915djed	INV-0015	msnz7hz4xhmou	2026-08-11	3	JDs	active	2026-08-11	sc_jds	\N	\N	\N
msnz94j6qindq	INV-0016	msnz9398r4uny	2026-08-11	3	JDs	active	2026-08-11	sc_jds	\N	\N	\N
mszgpuk7ro0e2	INV-0017	mszgpsyajq5ga	2026-08-19	3	JDs	active	2026-08-19	sc_jds	\N	\N	\N
mt0p3mgg9j2o7	INV-0018	mt0p3l4kghzwz	2026-08-19	3	GMW Jewellery	active	2026-08-19	sc_gmw	\N	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, slug, colour, gst_registered, gst_rate, income_tax_rate, active) FROM stdin;
1	Gabby	gabby	#5C7A6B	t	15.00	33.00	t
2	Paula	paula	#6E4B5E	f	0.00	17.50	t
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-04-17 02:08:30
20211116045059	2026-04-17 02:08:31
20211116050929	2026-04-17 02:08:31
20211116051442	2026-04-17 02:08:32
20211116212300	2026-04-17 02:08:33
20211116213355	2026-04-17 02:08:33
20211116213934	2026-04-17 02:08:34
20211116214523	2026-04-17 02:08:35
20211122062447	2026-04-17 02:08:36
20211124070109	2026-04-17 02:08:36
20211202204204	2026-04-17 02:08:37
20211202204605	2026-04-17 02:08:38
20211210212804	2026-04-17 02:08:40
20211228014915	2026-04-17 02:08:41
20220107221237	2026-04-17 02:08:41
20220228202821	2026-04-17 02:08:42
20220312004840	2026-04-17 02:08:43
20220603231003	2026-04-17 02:08:44
20220603232444	2026-04-17 02:08:44
20220615214548	2026-04-17 02:08:45
20220712093339	2026-04-17 02:08:46
20220908172859	2026-04-17 02:08:47
20220916233421	2026-04-17 02:08:47
20230119133233	2026-04-17 02:08:48
20230128025114	2026-04-17 02:08:49
20230128025212	2026-04-17 02:08:49
20230227211149	2026-04-17 02:08:50
20230228184745	2026-04-17 02:08:51
20230308225145	2026-04-17 02:08:51
20230328144023	2026-04-17 02:08:52
20231018144023	2026-04-17 02:08:53
20231204144023	2026-04-17 02:08:54
20231204144024	2026-04-17 02:08:55
20231204144025	2026-04-17 02:08:55
20240108234812	2026-04-17 02:08:56
20240109165339	2026-04-17 02:08:57
20240227174441	2026-04-17 02:08:58
20240311171622	2026-04-17 02:08:59
20240321100241	2026-04-17 02:09:00
20240401105812	2026-04-17 02:09:02
20240418121054	2026-04-17 02:09:03
20240523004032	2026-04-17 02:09:06
20240618124746	2026-04-17 02:09:06
20240801235015	2026-04-17 02:09:07
20240805133720	2026-04-17 02:09:08
20240827160934	2026-04-17 02:09:08
20240919163303	2026-04-17 02:09:09
20240919163305	2026-04-17 02:09:10
20241019105805	2026-04-17 02:09:10
20241030150047	2026-04-17 02:09:13
20241108114728	2026-04-17 02:09:14
20241121104152	2026-04-17 02:09:15
20241130184212	2026-04-17 02:09:15
20241220035512	2026-04-17 02:09:16
20241220123912	2026-04-17 02:09:17
20241224161212	2026-04-17 02:09:17
20250107150512	2026-04-17 02:09:18
20250110162412	2026-04-17 02:09:19
20250123174212	2026-04-17 02:09:19
20250128220012	2026-04-17 02:09:20
20250506224012	2026-04-17 02:09:21
20250523164012	2026-04-17 02:09:21
20250714121412	2026-04-17 02:09:22
20250905041441	2026-04-17 02:09:23
20251103001201	2026-04-17 02:09:23
20251120212548	2026-04-17 02:09:24
20251120215549	2026-04-17 02:09:25
20260218120000	2026-04-17 02:09:26
20260326120000	2026-04-17 02:09:26
20260514120000	2026-07-01 04:02:52
20260527120000	2026-07-01 04:02:53
20260528120000	2026-07-01 04:02:54
20260603120000	2026-07-01 04:02:55
20260605120000	2026-07-01 04:02:56
20260606110000	2026-07-01 04:02:57
20260616120000	2026-07-01 04:02:59
20260624120000	2026-07-01 04:03:00
20260626120000	2026-07-21 03:06:16
20260706120000	2026-07-21 03:06:17
20260707120000	2026-07-21 03:06:21
20260709120000	2026-07-21 03:06:22
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_realtime_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter, selected_columns) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-04-16 13:33:04.983515
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-04-16 13:33:05.019141
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-04-16 13:33:05.027573
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-04-16 13:33:05.053209
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-04-16 13:33:05.066693
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-04-16 13:33:05.073519
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-04-16 13:33:05.081464
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-04-16 13:33:05.089376
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-04-16 13:33:05.09636
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-04-16 13:33:05.103682
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-04-16 13:33:05.110307
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-04-16 13:33:05.117348
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-04-16 13:33:05.124335
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-04-16 13:33:05.130919
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-04-16 13:33:05.138462
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-04-16 13:33:05.165272
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-04-16 13:33:05.172688
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-04-16 13:33:05.17969
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-04-16 13:33:05.186671
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-04-16 13:33:05.195591
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-04-16 13:33:05.202563
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-04-16 13:33:05.210953
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-04-16 13:33:05.227901
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-04-16 13:33:05.240072
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-04-16 13:33:05.247087
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-04-16 13:33:05.253974
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-04-16 13:33:05.261016
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-04-16 13:33:05.267469
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-04-16 13:33:05.27405
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-04-16 13:33:05.280596
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-04-16 13:33:05.287441
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-04-16 13:33:05.293845
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-04-16 13:33:05.301011
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-04-16 13:33:05.307336
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-04-16 13:33:05.313366
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-04-16 13:33:05.319953
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-04-16 13:33:05.326208
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-04-16 13:33:05.332377
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-04-16 13:33:05.340643
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-04-16 13:33:05.354143
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-04-16 13:33:05.359987
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-04-16 13:33:05.365887
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-04-16 13:33:05.372695
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-04-16 13:33:05.379
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-04-16 13:33:05.385139
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-04-16 13:33:05.392471
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-04-16 13:33:05.404774
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-04-16 13:33:05.412285
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-04-16 13:33:05.419395
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-04-16 13:33:05.437832
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-04-16 13:33:05.445006
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-04-16 13:33:05.547233
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-04-16 13:33:05.549628
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-04-16 13:33:05.562693
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-04-16 13:33:05.566672
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-04-16 13:33:05.569189
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-16 13:33:05.584618
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-16 13:33:05.591789
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-04-16 13:33:05.576784
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-04-29 01:58:06.641415
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-05-05 04:47:43.17795
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 155, true);


--
-- Name: billing_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.billing_statuses_id_seq', 4, true);


--
-- Name: job_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_types_id_seq', 11, true);


--
-- Name: retailers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.retailers_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_realtime_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: billing_runs billing_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_runs
    ADD CONSTRAINT billing_runs_pkey PRIMARY KEY (id);


--
-- Name: billing_statuses billing_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_statuses
    ADD CONSTRAINT billing_statuses_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (name);


--
-- Name: job_types job_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_types
    ADD CONSTRAINT job_types_pkey PRIMARY KEY (id);


--
-- Name: nj_credit_notes nj_credit_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_credit_notes
    ADD CONSTRAINT nj_credit_notes_pkey PRIMARY KEY (id);


--
-- Name: nj_payments nj_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_payments
    ADD CONSTRAINT nj_payments_pkey PRIMARY KEY (id);


--
-- Name: nj_statement_lines nj_statement_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_statement_lines
    ADD CONSTRAINT nj_statement_lines_pkey PRIMARY KEY (id);


--
-- Name: nj_statements nj_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_statements
    ADD CONSTRAINT nj_statements_pkey PRIMARY KEY (id);


--
-- Name: packet_items packet_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packet_items
    ADD CONSTRAINT packet_items_pkey PRIMARY KEY (id);


--
-- Name: packets packets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packets
    ADD CONSTRAINT packets_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: id_reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.id_reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: id_reports reports_report_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.id_reports
    ADD CONSTRAINT reports_report_number_key UNIQUE (report_number);


--
-- Name: retailer_job_type_costs retailer_job_type_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailer_job_type_costs
    ADD CONSTRAINT retailer_job_type_costs_pkey PRIMARY KEY (retailer_id, job_type_id);


--
-- Name: retailers retailers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailers
    ADD CONSTRAINT retailers_pkey PRIMARY KEY (id);


--
-- Name: shipping_runs shipping_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_runs
    ADD CONSTRAINT shipping_runs_pkey PRIMARY KEY (id);


--
-- Name: sub_customers sub_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_customers
    ADD CONSTRAINT sub_customers_pkey PRIMARY KEY (id);


--
-- Name: tax_invoices tax_invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: tax_invoices tax_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_slug_key UNIQUE (slug);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: nj_credit_notes nj_credit_notes_nj_statement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_credit_notes
    ADD CONSTRAINT nj_credit_notes_nj_statement_id_fkey FOREIGN KEY (nj_statement_id) REFERENCES public.nj_statements(id);


--
-- Name: nj_statement_lines nj_statement_lines_credit_note_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_statement_lines
    ADD CONSTRAINT nj_statement_lines_credit_note_id_fkey FOREIGN KEY (credit_note_id) REFERENCES public.nj_credit_notes(id);


--
-- Name: nj_statement_lines nj_statement_lines_statement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_statement_lines
    ADD CONSTRAINT nj_statement_lines_statement_id_fkey FOREIGN KEY (statement_id) REFERENCES public.nj_statements(id);


--
-- Name: nj_statement_lines nj_statement_lines_tax_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nj_statement_lines
    ADD CONSTRAINT nj_statement_lines_tax_invoice_id_fkey FOREIGN KEY (tax_invoice_id) REFERENCES public.tax_invoices(id);


--
-- Name: packet_items packet_items_job_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packet_items
    ADD CONSTRAINT packet_items_job_type_id_fkey FOREIGN KEY (job_type_id) REFERENCES public.job_types(id);


--
-- Name: packet_items packet_items_packet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packet_items
    ADD CONSTRAINT packet_items_packet_id_fkey FOREIGN KEY (packet_id) REFERENCES public.packets(id);


--
-- Name: packets packets_retailer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packets
    ADD CONSTRAINT packets_retailer_id_fkey FOREIGN KEY (retailer_id) REFERENCES public.retailers(id);


--
-- Name: packets packets_shipping_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packets
    ADD CONSTRAINT packets_shipping_run_id_fkey FOREIGN KEY (shipping_run_id) REFERENCES public.shipping_runs(id);


--
-- Name: packets packets_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packets
    ADD CONSTRAINT packets_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.billing_statuses(id);


--
-- Name: packets packets_sub_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packets
    ADD CONSTRAINT packets_sub_customer_id_fkey FOREIGN KEY (sub_customer_id) REFERENCES public.sub_customers(id);


--
-- Name: profiles profiles_appraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_appraiser_id_fkey FOREIGN KEY (appraiser_id) REFERENCES public.users(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: retailer_job_type_costs retailer_job_type_costs_job_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailer_job_type_costs
    ADD CONSTRAINT retailer_job_type_costs_job_type_id_fkey FOREIGN KEY (job_type_id) REFERENCES public.job_types(id);


--
-- Name: retailer_job_type_costs retailer_job_type_costs_retailer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retailer_job_type_costs
    ADD CONSTRAINT retailer_job_type_costs_retailer_id_fkey FOREIGN KEY (retailer_id) REFERENCES public.retailers(id);


--
-- Name: shipping_runs shipping_runs_retailer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_runs
    ADD CONSTRAINT shipping_runs_retailer_id_fkey FOREIGN KEY (retailer_id) REFERENCES public.retailers(id);


--
-- Name: shipping_runs shipping_runs_sub_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_runs
    ADD CONSTRAINT shipping_runs_sub_customer_id_fkey FOREIGN KEY (sub_customer_id) REFERENCES public.sub_customers(id);


--
-- Name: sub_customers sub_customers_retailer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_customers
    ADD CONSTRAINT sub_customers_retailer_id_fkey FOREIGN KEY (retailer_id) REFERENCES public.retailers(id);


--
-- Name: tax_invoices tax_invoices_nj_statement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_nj_statement_id_fkey FOREIGN KEY (nj_statement_id) REFERENCES public.nj_statements(id);


--
-- Name: tax_invoices tax_invoices_retailer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_retailer_id_fkey FOREIGN KEY (retailer_id) REFERENCES public.retailers(id);


--
-- Name: tax_invoices tax_invoices_shipping_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_shipping_run_id_fkey FOREIGN KEY (shipping_run_id) REFERENCES public.shipping_runs(id);


--
-- Name: tax_invoices tax_invoices_sub_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_invoices
    ADD CONSTRAINT tax_invoices_sub_customer_id_fkey FOREIGN KEY (sub_customer_id) REFERENCES public.sub_customers(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: id_reports Allow anonymous access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow anonymous access" ON public.id_reports USING (true) WITH CHECK (true);


--
-- Name: billing_runs Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.billing_runs TO authenticated USING (true) WITH CHECK (true);


--
-- Name: billing_statuses Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.billing_statuses TO authenticated USING (true) WITH CHECK (true);


--
-- Name: id_reports Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.id_reports TO authenticated USING (true) WITH CHECK (true);


--
-- Name: items Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.items TO authenticated USING (true) WITH CHECK (true);


--
-- Name: job_types Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.job_types TO authenticated USING (true) WITH CHECK (true);


--
-- Name: nj_credit_notes Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.nj_credit_notes TO authenticated USING (true) WITH CHECK (true);


--
-- Name: nj_payments Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.nj_payments TO authenticated USING (true) WITH CHECK (true);


--
-- Name: nj_statement_lines Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.nj_statement_lines TO authenticated USING (true) WITH CHECK (true);


--
-- Name: nj_statements Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.nj_statements TO authenticated USING (true) WITH CHECK (true);


--
-- Name: packet_items Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.packet_items TO authenticated USING (true) WITH CHECK (true);


--
-- Name: packets Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.packets TO authenticated USING (true) WITH CHECK (true);


--
-- Name: profiles Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.profiles TO authenticated USING (true) WITH CHECK (true);


--
-- Name: retailer_job_type_costs Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.retailer_job_type_costs TO authenticated USING (true) WITH CHECK (true);


--
-- Name: retailers Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.retailers TO authenticated USING (true) WITH CHECK (true);


--
-- Name: shipping_runs Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.shipping_runs TO authenticated USING (true) WITH CHECK (true);


--
-- Name: sub_customers Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.sub_customers TO authenticated USING (true) WITH CHECK (true);


--
-- Name: tax_invoices Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.tax_invoices TO authenticated USING (true) WITH CHECK (true);


--
-- Name: users Authenticated staff access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated staff access" ON public.users TO authenticated USING (true) WITH CHECK (true);


--
-- Name: billing_runs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.billing_runs ENABLE ROW LEVEL SECURITY;

--
-- Name: billing_statuses; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.billing_statuses ENABLE ROW LEVEL SECURITY;

--
-- Name: id_reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.id_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;

--
-- Name: job_types; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.job_types ENABLE ROW LEVEL SECURITY;

--
-- Name: nj_credit_notes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.nj_credit_notes ENABLE ROW LEVEL SECURITY;

--
-- Name: nj_payments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.nj_payments ENABLE ROW LEVEL SECURITY;

--
-- Name: nj_statement_lines; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.nj_statement_lines ENABLE ROW LEVEL SECURITY;

--
-- Name: nj_statements; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.nj_statements ENABLE ROW LEVEL SECURITY;

--
-- Name: packet_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.packet_items ENABLE ROW LEVEL SECURITY;

--
-- Name: packets; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.packets ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: retailer_job_type_costs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.retailer_job_type_costs ENABLE ROW LEVEL SECURITY;

--
-- Name: retailers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.retailers ENABLE ROW LEVEL SECURITY;

--
-- Name: shipping_runs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shipping_runs ENABLE ROW LEVEL SECURITY;

--
-- Name: sub_customers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sub_customers ENABLE ROW LEVEL SECURITY;

--
-- Name: tax_invoices; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tax_invoices ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO service_role;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE billing_runs; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.billing_runs TO anon;
GRANT ALL ON TABLE public.billing_runs TO authenticated;
GRANT ALL ON TABLE public.billing_runs TO service_role;


--
-- Name: TABLE billing_statuses; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.billing_statuses TO anon;
GRANT ALL ON TABLE public.billing_statuses TO authenticated;
GRANT ALL ON TABLE public.billing_statuses TO service_role;


--
-- Name: SEQUENCE billing_statuses_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.billing_statuses_id_seq TO anon;
GRANT ALL ON SEQUENCE public.billing_statuses_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.billing_statuses_id_seq TO service_role;


--
-- Name: TABLE id_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE public.id_reports TO anon;
GRANT ALL ON TABLE public.id_reports TO authenticated;
GRANT ALL ON TABLE public.id_reports TO service_role;


--
-- Name: TABLE items; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.items TO anon;
GRANT ALL ON TABLE public.items TO authenticated;
GRANT ALL ON TABLE public.items TO service_role;


--
-- Name: TABLE job_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.job_types TO anon;
GRANT ALL ON TABLE public.job_types TO authenticated;
GRANT ALL ON TABLE public.job_types TO service_role;


--
-- Name: SEQUENCE job_types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.job_types_id_seq TO anon;
GRANT ALL ON SEQUENCE public.job_types_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.job_types_id_seq TO service_role;


--
-- Name: TABLE nj_credit_notes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nj_credit_notes TO anon;
GRANT ALL ON TABLE public.nj_credit_notes TO authenticated;
GRANT ALL ON TABLE public.nj_credit_notes TO service_role;


--
-- Name: TABLE nj_payments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nj_payments TO anon;
GRANT ALL ON TABLE public.nj_payments TO authenticated;
GRANT ALL ON TABLE public.nj_payments TO service_role;


--
-- Name: TABLE nj_statement_lines; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nj_statement_lines TO anon;
GRANT ALL ON TABLE public.nj_statement_lines TO authenticated;
GRANT ALL ON TABLE public.nj_statement_lines TO service_role;


--
-- Name: TABLE nj_statements; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nj_statements TO anon;
GRANT ALL ON TABLE public.nj_statements TO authenticated;
GRANT ALL ON TABLE public.nj_statements TO service_role;


--
-- Name: TABLE packet_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.packet_items TO anon;
GRANT ALL ON TABLE public.packet_items TO authenticated;
GRANT ALL ON TABLE public.packet_items TO service_role;


--
-- Name: TABLE packets; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.packets TO anon;
GRANT ALL ON TABLE public.packets TO authenticated;
GRANT ALL ON TABLE public.packets TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE retailer_job_type_costs; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.retailer_job_type_costs TO anon;
GRANT ALL ON TABLE public.retailer_job_type_costs TO authenticated;
GRANT ALL ON TABLE public.retailer_job_type_costs TO service_role;


--
-- Name: TABLE retailers; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.retailers TO anon;
GRANT ALL ON TABLE public.retailers TO authenticated;
GRANT ALL ON TABLE public.retailers TO service_role;


--
-- Name: SEQUENCE retailers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.retailers_id_seq TO anon;
GRANT ALL ON SEQUENCE public.retailers_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.retailers_id_seq TO service_role;


--
-- Name: TABLE shipping_runs; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.shipping_runs TO anon;
GRANT ALL ON TABLE public.shipping_runs TO authenticated;
GRANT ALL ON TABLE public.shipping_runs TO service_role;


--
-- Name: TABLE sub_customers; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.sub_customers TO anon;
GRANT ALL ON TABLE public.sub_customers TO authenticated;
GRANT ALL ON TABLE public.sub_customers TO service_role;


--
-- Name: TABLE tax_invoices; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.tax_invoices TO anon;
GRANT ALL ON TABLE public.tax_invoices TO authenticated;
GRANT ALL ON TABLE public.tax_invoices TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT REFERENCES,TRIGGER,TRUNCATE,MAINTAIN ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO anon;
GRANT ALL ON SEQUENCE public.users_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.users_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict ScdoMfpErucHm6zSNQAzFouE3Lb3DLiyNZHVXFigU89ixOK8pGj8fms68M8Ld1c

